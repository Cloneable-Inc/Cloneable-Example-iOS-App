import SwiftUI
import PDFKit
import CloneableCore
import CloneablePlatformiOS

struct PdfViewComponent: View, ComponentView {
    var staticComponentID: String
    var dynamicComponentID: String
    var component: DeployedWorkflow_components
    @StateObject var viewModel: PDFViewModel

    init(staticComponentID: String, dynamicComponentID: String, component: DeployedWorkflow_components) {
        self.staticComponentID = staticComponentID
        self.dynamicComponentID = dynamicComponentID
        self.component = component
        _viewModel = StateObject(wrappedValue: PDFViewModel(dynamicComponentID: dynamicComponentID,
                                                            staticComponentID: staticComponentID,
                                                            component: component))
    }

    @State private var showShareSheet: Bool = false

    var body: some View {
        VStack {
            shareButton
            PdfViewUI(data: $viewModel.pdfData, autoScales: true)
            Spacer()
            nextButton
        }
        .navigationTitle("Your PDF")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showShareSheet) {
            if let data = viewModel.pdfData?.dataRepresentation() {
                ShareView(activityItems: [data])
            }
        }
    }
}

private extension PdfViewComponent {
    var shareButton: some View {
        Button(action: { showShareSheet.toggle() }) {
            Image(systemName: "square.and.arrow.up")
                .font(.title2)
                .foregroundColor(.gray)
        }
        .padding([.leading, .trailing])
    }

    var nextButton: some View {
        Button(action: viewModel.nextButtonClick) {
            Text("Next")
                .frame(width: 296, height: 47)
                .background(Color.blue)
                .cornerRadius(10)
                .foregroundColor(.white)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.bottom)
    }
}

struct PdfViewUI: UIViewRepresentable {
    @Binding var data: PDFDocument?
    let autoScales: Bool

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = autoScales
        pdfView.document = data
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        uiView.document = data
    }
}

struct ShareView: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
    }
}
