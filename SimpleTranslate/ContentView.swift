//
//  ContentView.swift
//  SimpleTranslate
//
//  Created by Stahsf on 2024/5/18.
//

import SwiftUI

struct ContentView: View {
    @State private var originText: String = ""
    @State private var hasResult = false
    @State private var resultText: String = "翻译结果展示区域"
    
    var body: some View {
        VStack {
            VStack(spacing: 10, content: {
                
                TextField("请输入需要翻译的内容", text: $originText, axis: .vertical)
                    .lineLimit(nil) // 允许无限行
                    .lineSpacing(10)
                    .disableAutocorrection(true)
                    .frame(maxHeight: 300) // 自适应高度
                    .padding(.all, 10)
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.clear, lineWidth: 0)
                    )
                    .textFieldStyle(PlainTextFieldStyle())
                    .alignmentGuide(.top, computeValue: { dimension in
                        dimension[.top]
                    })
                    .onSubmit {
                        translate()
                    }
                
                Image(systemName: "arrow.down")
                
                TextEditor(text: $resultText)
                    .foregroundColor(hasResult ? .black : .black.opacity(0.6))
                    .lineLimit(5)
                    .lineSpacing(10)
                    .disableAutocorrection(true)
                    .frame(maxHeight: 300)
                    .padding(.all, 10)
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                    .disabled(true)
                    .onTapGesture {
                        if (hasResult) {
                            copyToClipBoard(textToCopy: resultText)
                        }
                    }
                
            })
        }
        .padding(10)
        .frame(width: 300)
    }
    
    func copyToClipBoard(textToCopy: String) {
      let pasteBoard = NSPasteboard.general
      pasteBoard.clearContents()
      pasteBoard.setString(textToCopy, forType: .string)
    }
    
    func translate() {
        if let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
           let configDict = NSDictionary(contentsOfFile: path) as? [String: Any],
           let apiUrl = configDict["APIUrl"] as? String,
           let apiKey = configDict["APIKey"] as? String {
            NetworkManager
                .shared
                .fetchData(
                    from: apiUrl,
                    body: [
                        "model": "deepseek-chat",
                        "messages": [
                            ["role": "system", "content": """
你是一个翻译家，你能根据我给出的文本，自动识别其语言（中文或英文），并将其翻译成另一种语言。请确保翻译准确无误，不需要回答问题，并只返回最终的翻译结果。

文本示例："Hello, how are you?"
输出示例：你好，你好吗？

文本示例："你好，今天天气怎么样？"
输出示例：Hello, how is the weather today?
"""],
                            ["role": "user",
                             "content": originText]
                        ],
                        "stream": false
                    ],
                    headers: ["Authorization": "Bearer \(apiKey)", "Content-Type": "application/json"]
                ) {
                    result in
                    switch result {
                    case .success(let data):
                        print("Response: \(data)")
                        if let jsonData = data as? [String: Any],
                           let choices = jsonData["choices"] as? [[String: Any]],
                           let firstMessage = choices.first?["message"] as? [String: Any],
                           let content = firstMessage["content"] as? String {
                            print("Content: \(content)")
                            hasResult = true
                            resultText = content
                        }
                    case .failure(let error):
                        resultText = "Error: \(error.localizedDescription)"
                        print("Error: \(error.localizedDescription)")
                    }
                }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
