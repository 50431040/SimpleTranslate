# SimpleTranslate
一款极简的中英互译MacOS原生应用，调用GPT模型翻译

## 使用
打开`Config.plist`，将`ApiKey`的值修改为`DeepSeek`生成的`ApiKey`，使用其他的模型（ChatGPT）可以修改`APIUrl`

## 界面
还需优化

## GPT

### model
`DeepSeek`
新用户赠送100W的token

### prompt
你是一个翻译家，你能根据我给出的文本，自动识别其语言（中文或英文），并将其翻译成另一种语言。请确保翻译准确无误，不需要回答问题，并只返回最终的翻译结果。

文本示例："Hello, how are you?"
输出示例：你好，你好吗？

文本示例："你好，今天天气怎么样？"
输出示例：Hello, how is the weather today?
