# learning_qml
存储学习qml期间的代码

### 使用的是<<Qt Quick核心编程>>

由于此书是Qt5的教学内容,而我使用的是Qt6.8.2,截至目前发现了一些差异

- 书中使用到了QtQuick.Controls.Styles模块,但Qt6 已经删除了此模块.

- 在书中实现槽函数的时候,会出现警告参数event未定义,

  ```c++
  例如书中键盘按钮移动文本例子中:Keys.onPressed:{switch(event.key){}event.accepted = true;}就会出现event未定义
  只需要添加  `(event)=>`  就可以取消此警告
  Keys.onPressed:(event)=>{switch(event.key){}event.accepted = true;}
  ```


- 在Main.qml中使用其他qml文件时发现qml文件命名首字母得大写,否则无法识别到
- 使用Connections连接信号和槽函数时,qt6书写方式发生改变,直接查看[day02](./day02/day02.md)
- Qt6不再使用Component定义控件的Sytle样式做原型,由于Styles模块已移除且Component已不再用于自定义组件[day03](./day03/day03.md)





学习进度

##### day_01--2025/4/20 

观看第1~6章,完成初识qml

##### day_02--2025/4/21

完成6~7章结束
