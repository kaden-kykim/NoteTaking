//
//  NoteTextView.swift
//  NoteTaking
//
//  Created by Kaden Kim on 2020-10-21.
//

import RxSwift

class NoteTextView: UITextView {

    // MARK: - Constant Properties
    private static let noteDefaultFont = UIFont.systemFont(ofSize: 17)
    private static let noteDefaultFontColor = UIColor.label
    private static let noteDefaultFontBackgroundColor = UIColor.clear
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    fileprivate weak var viewModel: NoteViewModel?
    fileprivate var changedNoteRange = NSRange()
    
    // MARK: - Initialization
    required init(viewModel: NoteViewModel) {
        super.init(frame: .zero, textContainer: nil)
        self.viewModel = viewModel
        
        setupView()
        bindOnNote()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
}

// MARK: - Bindings
extension NoteTextView {
    private func bindOnNote() {
        guard let viewModel = viewModel else { return }
        viewModel.noteDidLoad
            .subscribe(onNext: { [weak self] attributedString in
                DispatchQueue.main.async {
                    self?.attributedText = attributedString
                    self?.setDefaultAttributesString()
                    self?.alignImageAttachment()
                }
            }).disposed(by: disposeBag)
        
        viewModel.toggleStyle
            .subscribe(onNext: { [weak self] in
                let toEnable = !$1
                switch $0 {
                case .bold, .italic:
                    if let font = self?.typingAttributes[.font] as? UIFont {
                        let newFont = $0 == .bold ? font.toggleSemiBold() : font.toggleItalic()
                        self?.typingAttributes[.font] = newFont
                        if let range = self?.selectedRange, range.length > 0 {
                            self?.textStorage.addAttribute(.font, value: newFont, range: range)
                            if let self = self { self.noteDidChangeEvent() }
                        }
                    }
                case .underline, .strikethrough:
                    let key: NSAttributedString.Key = $0 == .underline ? .underlineStyle : .strikethroughStyle
                    guard let self = self else { return }
                    if toEnable { self.typingAttributes[key] = 1 }
                    else { self.typingAttributes.removeValue(forKey: key) }
                    let range = self.selectedRange
                    if range.length > 0 {
                        if toEnable { self.textStorage.addAttribute(key, value: 1, range: range) }
                        else { self.textStorage.removeAttribute(key, range: range) }
                        self.noteDidChangeEvent()
                    }
                }
                if let viewModel = self?.viewModel {
                    var fontStatus = viewModel.fontStyleStatus.value
                    fontStatus[$0.rawValue] = toEnable
                    viewModel.fontStyleStatus.accept(fontStatus)
                }
            }).disposed(by: disposeBag)
        
        viewModel.attachImageFromPicker
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let textAttachment = NSTextAttachment()
                textAttachment.image = $0.resize(toWidth: max(self.frame.width, self.frame.height) * 0.975)
                var selectedRange = self.selectedRange
                let attrString = self.attributedText.mutableCopy() as! NSMutableAttributedString
                attrString.replaceCharacters(in: selectedRange, with: NSAttributedString(attachment: textAttachment))
                let newLineString = NSMutableAttributedString(string: "\n")
                newLineString.setFont(NoteTextView.noteDefaultFont, range: NSMakeRange(0, newLineString.length))
                attrString.insert(newLineString, at: selectedRange.location + selectedRange.length + 1)
                self.attributedText = attrString
                selectedRange.location += newLineString.length + 1
                self.selectedRange = selectedRange
                self.alignImageAttachment()
                self.noteDidChangeEvent()
            }).disposed(by: disposeBag)
        
        viewModel.noteUndo.subscribe(onNext: { [weak self] in self?.undoManager?.undo() }).disposed(by: disposeBag)
        viewModel.noteRedo.subscribe(onNext: { [weak self] in self?.undoManager?.redo() }).disposed(by: disposeBag)
        
        viewModel.screenRotated
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .landscapeLeft, .landscapeRight, .portrait:
                    self?.alignImageAttachment()
                default: break
                }
            }).disposed(by: disposeBag)
        
        rx.didBeginEditing
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.viewModel?.setEditing.accept(true)
                if let textRange = self.selectedTextRange {
                    self.scrollRectToVisible(self.caretRect(for: textRange.start), animated: true)
                }
            }).disposed(by: disposeBag)

        rx.didChange.subscribe(onNext: { [weak self] _ in self?.noteDidChangeEvent() }).disposed(by: disposeBag)

        rx.didChangeSelection
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.changedNoteRange.length = self.selectedRange.location - self.changedNoteRange.location
                var fontStyle = [Bool](repeating: false, count: NoteFontStyle.allCases.count)
                if let font = self.typingAttributes[.font] as? UIFont {
                    self.typingAttributes[.font] = font.copyTraits(to: NoteTextView.noteDefaultFont)
                    fontStyle[NoteFontStyle.bold.rawValue] = font.fontDescriptor.symbolicTraits.contains(.traitBold)
                    fontStyle[NoteFontStyle.italic.rawValue] = font.fontDescriptor.symbolicTraits.contains(.traitItalic)
                }
                fontStyle[NoteFontStyle.underline.rawValue] = self.typingAttributes[.underlineStyle] != nil
                fontStyle[NoteFontStyle.strikethrough.rawValue] = self.typingAttributes[.strikethroughStyle] != nil
                self.viewModel?.fontStyleStatus.accept(fontStyle)

                self.typingAttributes[.foregroundColor] = UIColor.label
                self.typingAttributes[.backgroundColor] = UIColor.clear
            }).disposed(by: disposeBag)
        
        let delegate = NoteTextViewDelegate()
        delegate.noteTextView = self
        rx.delegate.setForwardToDelegate(delegate, retainDelegate: true)
    }
}

// MARK: - TextView Helper Methods
extension NoteTextView {
    
    private func alignImageAttachment(range: NSRange? = nil) {
        let range = range ?? NSMakeRange(0, attributedText.length)
        guard range.length >= 0 else { return }
        DispatchQueue.main.async { [weak self] in
            self?.isScrollEnabled = false
            defer { self?.isScrollEnabled = true }
            if let self = self, let attrText = self.attributedText.mutableCopy() as? NSMutableAttributedString {
                attrText.alignTextAttachment(of: self.bounds.width * 0.975, range: range)
                self.attributedText = attrText
            }
        }
    }
    
    private func setDefaultAttributesString(range: NSRange? = nil) {
        let range = range ?? NSMakeRange(0, attributedText.length)
        guard range.length > 1 else { return }
        DispatchQueue.main.async { [weak self] in
            self?.isScrollEnabled = false
            defer { self?.isScrollEnabled = true }
            if let attrString = self?.attributedText,
               let mutableAttrString = attrString.mutableCopy() as? NSMutableAttributedString {
                if range.location + range.length <= mutableAttrString.length {
                    mutableAttrString.setFontWithoutTraits(NoteTextView.noteDefaultFont, range: range)
                    mutableAttrString.setFontColor(range: range)
                    self?.attributedText = mutableAttrString
                    self?.selectedRange = NSMakeRange(range.location + range.length, 0)
                }
            }
        }
    }
    
    private func noteDidChangeEvent() {
        viewModel?.noteDidChange.accept(attributedText)
        DispatchQueue.main.async { [weak self] in
            self?.viewModel?.canUndo.accept(self?.undoManager?.canUndo ?? false)
            self?.viewModel?.canRedo.accept(self?.undoManager?.canRedo ?? false)
        }
    }
    
}

extension NoteTextView {
    func setupView() {
        isEditable = true
        autocorrectionType = .no
        typingAttributes = [NSAttributedString.Key.font: NoteTextView.noteDefaultFont,
                            NSAttributedString.Key.foregroundColor: NoteTextView.noteDefaultFontColor,
                            NSAttributedString.Key.backgroundColor: NoteTextView.noteDefaultFontBackgroundColor]
    }
}

// MARK: - Delegate class
class NoteTextViewDelegate: NSObject, UITextViewDelegate {
    
    weak var noteTextView: NoteTextView?
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        noteTextView?.changedNoteRange.location = range.location
        return true
    }

    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        guard let note = noteTextView else { return false }
        if let newPositionFrom = note.position(from: note.beginningOfDocument, offset: characterRange.location + characterRange.length - 1),
           let newPositionTo = note.position(from: note.beginningOfDocument, offset: characterRange.location + characterRange.length) {
            note.selectedTextRange = note.textRange(from: newPositionFrom, to: newPositionTo)
        }
        noteTextView?.viewModel?.setEditing.accept(true)
        switch interaction {
        case .presentActions: return false
        default: return true
        }
    }

}
