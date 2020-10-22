//
//  NoteTextView.swift
//  NoteTaking
//
//  Created by Kaden Kim on 2020-10-21.
//

import RxSwift

class NoteTextView: UITextView {

    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private weak var viewModel: NoteViewModel?
    
    // MARK: - Initialization
    required init(viewModel: NoteViewModel) {
        super.init(frame: .zero, textContainer: nil)
        self.viewModel = viewModel
        
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
}

extension NoteTextView {
    func setupView() {
        isEditable = true
        autocorrectionType = .no
        // View test
        text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Id volutpat lacus laoreet non curabitur gravida arcu ac tortor.Nec ullamcorper sit amet risus nullam. Pretium viverra suspendisse potenti nullam ac tortor. Nunc sed blandit libero volutpat sed cras ornare arcu. Sed euismod nisi porta lorem mollis. Cursus sit amet dictum sit amet justo donec enim. Ipsum dolor sit amet consectetur adipiscing elit pellentesque. Pellentesque sit amet porttitor eget. Sed odio morbi quis commodo odio aenean sed adipiscing. Et ultrices neque ornare aenean euismod elementum nisi. Nibh praesent tristique magna sit amet purus gravida quis. Eget magna fermentum iaculis eu non diam phasellus vestibulum. Integer eget aliquet nibh praesent. Non enim praesent elementum facilisis. Eget mi proin sed libero enim sed faucibus. Iaculis eu non diam phasellus vestibulum lorem. Eget nulla facilisi etiam dignissim diam. Viverra accumsan in nisl nisi scelerisque eu. Pellentesque dignissim enim sit amet. Vel elit scelerisque mauris pellentesque pulvinar pellentesque habitant morbi tristique. Adipiscing diam donec adipiscing tristique. Ut eu sem integer vitae. Gravida neque convallis a cras semper auctor neque vitae. Non tellus orci ac auctor augue mauris augue. Et egestas quis ipsum suspendisse ultrices. Faucibus turpis in eu mi bibendum neque egestas congue. Malesuada fames ac turpis egestas maecenas pharetra convallis. Neque gravida in fermentum et sollicitudin. Nunc sed blandit libero volutpat sed cras ornare arcu. Pulvinar neque laoreet suspendisse interdum consectetur libero. Molestie ac feugiat sed lectus vestibulum mattis. Sit amet massa vitae tortor. Tempus urna et pharetra pharetra massa massa. Sodales ut eu sem integer vitae justo. Eget nulla facilisi etiam dignissim diam quis. Id cursus metus aliquam eleifend. Mauris a diam maecenas sed enim ut sem viverra. Tellus integer feugiat scelerisque varius morbi enim nunc faucibus a. Convallis a cras semper auctor neque vitae. Purus non enim praesent elementum. Amet risus nullam eget felis. Condimentum id venenatis a condimentum vitae sapien pellentesque habitant. Malesuada fames ac turpis egestas maecenas. Lorem sed risus ultricies tristique nulla. Diam sit amet nisl suscipit adipiscing. Ornare aenean euismod elementum nisi quis eleifend quam. Vestibulum mattis ullamcorper velit sed ullamcorper morbi tincidunt. Donec adipiscing tristique risus nec feugiat in fermentum posuere urna. Morbi tristique senectus et netus et malesuada fames ac. Orci ac auctor augue mauris augue neque gravida in. Ut placerat orci nulla pellentesque dignissim. Suspendisse potenti nullam ac tortor. Scelerisque purus semper eget duis at tellus at urna. Tortor pretium viverra suspendisse potenti. Magna sit amet purus gravida. Consequat interdum varius sit amet mattis vulputate. Faucibus purus in massa tempor nec feugiat. Etiam sit amet nisl purus in mollis nunc sed id. Vulputate dignissim suspendisse in est ante in. Eu augue ut lectus arcu bibendum at varius vel. Dolor sit amet consectetur adipiscing elit pellentesque habitant. Mauris pharetra et ultrices neque ornare aenean euismod elementum. Metus dictum at tempor commodo. Sed nisi lacus sed viverra tellus in. Dolor magna eget est lorem. Mus mauris vitae ultricies leo integer malesuada nunc. Duis convallis convallis tellus id. Viverra orci sagittis eu volutpat odio facilisis mauris sit. Et pharetra pharetra massa massa ultricies mi quis. Habitasse platea dictumst vestibulum rhoncus. Euismod quis viverra nibh cras pulvinar mattis nunc sed blandit. Lobortis scelerisque fermentum dui faucibus. Lobortis mattis aliquam faucibus purus in massa. At volutpat diam ut venenatis tellus in metus. Diam sollicitudin tempor id eu nisl nunc mi ipsum. Eros in cursus turpis massa tincidunt dui ut ornare lectus. Rhoncus aenean vel elit scelerisque mauris. Sem et tortor consequat id porta nibh venenatis. Eleifend mi in nulla posuere sollicitudin aliquam ultrices sagittis. Odio ut sem nulla pharetra diam sit amet nisl. Egestas pretium aenean pharetra magna ac placerat vestibulum lectus mauris. Curabitur vitae nunc sed velit dignissim. Id ornare arcu odio ut sem. Nunc vel risus commodo viverra maecenas accumsan lacus. Condimentum lacinia quis vel eros donec. Ornare aenean euismod elementum nisi quis. At urna condimentum mattis pellentesque id nibh tortor id aliquet. Proin fermentum leo vel orci porta. Egestas dui id ornare arcu odio ut. Eget egestas purus viverra accumsan in nisl. Amet dictum sit amet justo donec. Sed viverra ipsum nunc aliquet. Augue interdum velit euismod in pellentesque massa placerat. Suspendisse sed nisi lacus sed. Et tortor at risus viverra adipiscing at. Duis ut diam quam nulla porttitor massa. Arcu non odio euismod lacinia at. Scelerisque eu ultrices vitae auctor eu. Turpis egestas maecenas pharetra convallis. Sit amet risus nullam eget. Pellentesque pulvinar pellentesque habitant morbi tristique senectus. Pellentesque adipiscing commodo elit at. Tellus at urna condimentum mattis pellentesque id. Magna sit amet purus gravida quis blandit turpis. Interdum varius sit amet mattis. Suspendisse sed nisi lacus sed viverra tellus in hac habitasse. Vitae suscipit tellus mauris a diam maecenas sed. Magna fringilla urna porttitor rhoncus dolor purus non enim praesent. Vitae congue eu consequat ac. Id venenatis a condimentum vitae sapien pellentesque habitant morbi. Et leo duis ut diam quam. Neque gravida in fermentum et sollicitudin. Magna etiam tempor orci eu lobortis elementum nibh tellus molestie. At quis risus sed vulputate odio ut. Ipsum suspendisse ultrices gravida dictum fusce. Id neque aliquam vestibulum morbi blandit cursus risus at. Consequat ac felis donec et odio pellentesque diam volutpat. Enim eu turpis egestas pretium aenean pharetra. Diam quis enim lobortis scelerisque. Ultricies leo integer malesuada nunc vel. Sed viverra ipsum nunc aliquet bibendum enim facilisis gravida neque. A arcu cursus vitae congue. Ut tristique et egestas quis ipsum suspendisse ultrices gravida dictum. Egestas erat imperdiet sed euismod nisi porta lorem. Elit duis tristique sollicitudin nibh sit. Accumsan lacus vel facilisis volutpat. Dictum varius duis at consectetur lorem donec. Ultricies leo integer malesuada nunc vel risus. Sit amet consectetur adipiscing elit ut aliquam purus. Sit amet consectetur adipiscing elit pellentesque habitant morbi tristique senectus. Tellus mauris a diam maecenas sed enim. A cras semper auctor neque vitae tempus quam pellentesque nec. Lectus urna duis convallis convallis. Imperdiet sed euismod nisi porta lorem mollis aliquam. Faucibus pulvinar elementum integer enim neque volutpat ac tincidunt vitae. Blandit volutpat maecenas volutpat blandit aliquam etiam erat velit scelerisque. Dictum at tempor commodo ullamcorper a lacus vestibulum. In dictum non consectetur a erat nam at lectus urna. Quam lacus suspendisse faucibus interdum posuere lorem ipsum. Quis blandit turpis cursus in hac habitasse platea. Sed viverra ipsum nunc aliquet bibendum enim facilisis gravida. Nisi quis eleifend quam adipiscing vitae proin. Cras ornare arcu dui vivamus arcu felis bibendum ut tristique. Lobortis scelerisque fermentum dui faucibus in ornare quam. Tincidunt tortor aliquam nulla facilisi cras fermentum. Netus et malesuada fames ac turpis egestas maecenas pharetra. Risus nec feugiat in fermentum posuere urna nec. Non sodales neque sodales ut. Ante metus dictum at tempor commodo ullamcorper a lacus vestibulum. Nisi vitae suscipit tellus mauris a diam maecenas sed. Auctor eu augue ut lectus arcu. Scelerisque in dictum non consectetur. Tortor at risus viverra adipiscing. Sit amet luctus venenatis lectus magna. Mauris commodo quis imperdiet massa tincidunt nunc. Bibendum enim facilisis gravida neque convallis a cras semper auctor."
    }
}
