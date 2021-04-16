# Useful Link
- [Figma](https://www.figma.com/file/8c7aaM7cegiuANSyib733p/NFT_Sotanext)
- [Code Convention](https://github.com/dangkyokhoang/javascript-style-guide) 

# Conventional Commit
## I. Cấu trúc tiêu chuẩn
Một nội dung thông báo của commit cần được cấu trúc như sau:
<PRE style="margin: 0px 0px 16px;padding: 16px;font-family: SFMono-Regular, Consolas, &amp;quot;font-size: 13.6px;line-height: 1.45;background-color: rgb(246, 248, 250);color: rgb(36, 41, 46);font-style: normal;font-weight: 400;letter-spacing: normal;text-align: start;text-indent: 0px;text-transform: none;word-spacing: 0px"><CODE style="margin: 0px;padding: 0px;font-family: SFMono-Regular, Consolas, &amp;quot;font-size: 13.6px;background: transparent;white-space: pre;border: 0px;line-height: inherit">&lt;type&gt;[optional scope]: &lt;description&gt;

[optional body]

[optional footer]</CODE></PRE>

## II. Các nhãn của commit
1. **fix:** một commit có nhãn <SPAN style="color: rgb(36, 41, 46);font-family: -apple-system, BlinkMacSystemFont, &amp;quot;font-size: 16px;font-style: normal;font-weight: 400;letter-spacing: normal;text-align: left;text-indent: 0px;text-transform: none;white-space: normal;word-spacing: 0px;background-color: rgb(255, 255, 255);float: none"><SPAN> </SPAN></SPAN><CODE style="margin: 0px;padding: 0.2em 0.4em;font-family: SFMono-Regular, Consolas, &amp;quot;font-size: 13.6px;background-color: rgba(27, 31, 35, 0.05);color: rgb(36, 41, 46);font-style: normal;font-weight: 400;letter-spacing: normal;text-align: left;text-indent: 0px;text-transform: none;white-space: normal;word-spacing: 0px">fix</CODE><SPAN style="color: rgb(36, 41, 46);font-family: -apple-system, BlinkMacSystemFont, &amp;quot;font-size: 16px;font-style: normal;font-weight: 400;letter-spacing: normal;text-align: left;text-indent: 0px;text-transform: none;white-space: normal;word-spacing: 0px;background-color: rgb(255, 255, 255);float: none"><SPAN> </SPAN></SPAN> có nghĩa là sẽ sửa **một** lỗi trong codebase.
2. **feat:** một commit có nhãn <SPAN style="color: rgb(36, 41, 46);font-family: -apple-system, BlinkMacSystemFont, &amp;quot;font-size: 16px;font-style: normal;font-weight: 400;letter-spacing: normal;text-align: left;text-indent: 0px;text-transform: none;white-space: normal;word-spacing: 0px;background-color: rgb(255, 255, 255);float: none"><SPAN> </SPAN></SPAN><CODE style="margin: 0px;padding: 0.2em 0.4em;font-family: SFMono-Regular, Consolas, &amp;quot;font-size: 13.6px;background-color: rgba(27, 31, 35, 0.05);color: rgb(36, 41, 46);font-style: normal;font-weight: 400;letter-spacing: normal;text-align: left;text-indent: 0px;text-transform: none;white-space: normal;word-spacing: 0px">feat</CODE><SPAN style="color: rgb(36, 41, 46);font-family: -apple-system, BlinkMacSystemFont, &amp;quot;font-size: 16px;font-style: normal;font-weight: 400;letter-spacing: normal;text-align: left;text-indent: 0px;text-transform: none;white-space: normal;word-spacing: 0px;background-color: rgb(255, 255, 255);float: none"><SPAN> </SPAN></SPAN> có ý nghĩa là giới thiệu một chức năng mới.
3. **BREAKING CHANGE:** một commit có nội dung <SPAN style="color: rgb(36, 41, 46);font-family: -apple-system, BlinkMacSystemFont, &amp;quot;font-size: 16px;font-style: normal;font-weight: 400;letter-spacing: normal;text-align: left;text-indent: 0px;text-transform: none;white-space: normal;word-spacing: 0px;background-color: rgb(255, 255, 255);float: none"><SPAN> </SPAN></SPAN><CODE style="margin: 0px;padding: 0.2em 0.4em;font-family: SFMono-Regular, Consolas, &amp;quot;font-size: 13.6px;background-color: rgba(27, 31, 35, 0.05);color: rgb(36, 41, 46);font-style: normal;font-weight: 400;letter-spacing: normal;text-align: left;text-indent: 0px;text-transform: none;white-space: normal;word-spacing: 0px">BREAKING CHANGE:</CODE><SPAN style="color: rgb(36, 41, 46);font-family: -apple-system, BlinkMacSystemFont, &amp;quot;font-size: 16px;font-style: normal;font-weight: 400;letter-spacing: normal;text-align: left;text-indent: 0px;text-transform: none;white-space: normal;word-spacing: 0px;background-color: rgb(255, 255, 255);float: none"><SPAN> </SPAN></SPAN> ở đầu phần tùy chọn nội dung hoặc chân trang giới thiệu một thay đổi lớn ở API (liên quan với nhãn MAJOR). MỘT BREAKING CHANGE có thể là một phần của bất kỳ loại commit nào.
4. Các loại commit khác:
    - **chore:** Các thay đổi linh tinh
    - **docs:** Chỉ thay đổi tài liệu
    - **style:** Chỉ thay đổi format code, không liên quan đến logic (white-space, chấm phẩy, ...)
    - **refactor:** Thay đổi codebase mà không liên quan đến sửa bug, thêm chức năng.
    - **perf:** Thay đổi codebase để nâng cấp hiệu năng
    - **test:** Thêm use-case testing hoặc unit-test
    - **revert:** Revert commit trước đó
    - **ci:** Thay đổi cấu hình các tệp và các scripts CI (vdu: Travis, Circle, BrowserStack, SauceLabs)
    - **build:** Các thay đổi liên quan đến việc build, ...
## III. Ví dụ
### Thông báo của commit với mô tả và thay đổi lớn trong nội dung
<PRE style="margin: 0px 0px 16px;padding: 16px;font-family: SFMono-Regular, Consolas, &amp;quot;font-size: 13.6px;line-height: 1.45;background-color: rgb(246, 248, 250);color: rgb(36, 41, 46);font-style: normal;font-weight: 400;letter-spacing: normal;text-align: start;text-indent: 0px;text-transform: none;word-spacing: 0px"><CODE style="margin: 0px;padding: 0px;font-family: SFMono-Regular, Consolas, &amp;quot;font-size: 13.6px;background: transparent;white-space: pre;border: 0px;line-height: inherit">feat: allow provided config object to extend other configs

BREAKING CHANGE: `extends` key in config file is now used for extending other config files</CODE></PRE>
### Commit thông báo với tùy chọn"!" để nhấn mạnh những thay đổi
<PRE style="margin: 0px 0px 16px;padding: 16px;font-family: SFMono-Regular, Consolas, &amp;quot;font-size: 13.6px;line-height: 1.45;background-color: rgb(246, 248, 250);color: rgb(36, 41, 46);font-style: normal;font-weight: 400;letter-spacing: normal;text-align: start;text-indent: 0px;text-transform: none;word-spacing: 0px"><CODE style="margin: 0px;padding: 0px;font-family: SFMono-Regular, Consolas, &amp;quot;font-size: 13.6px;background: transparent;white-space: pre;border: 0px;line-height: inherit">chore!: drop Node 6 from testing matrix

BREAKING CHANGE: dropping Node 6 which hits end of life in April</CODE></PRE>

### Commit không có nội dung
<PRE style="margin: 0px 0px 16px;padding: 16px;font-family: SFMono-Regular, Consolas, &amp;quot;font-size: 13.6px;line-height: 1.45;background-color: rgb(246, 248, 250);color: rgb(36, 41, 46);font-style: normal;font-weight: 400;letter-spacing: normal;text-align: start;text-indent: 0px;text-transform: none;word-spacing: 0px"><CODE style="margin: 0px;padding: 0px;font-family: SFMono-Regular, Consolas, &amp;quot;font-size: 13.6px;background: transparent;white-space: pre;border: 0px;line-height: inherit">docs: correct spelling of CHANGELOG</CODE></PRE>

### Commit với phạm vi
<PRE style="margin: 0px 0px 16px;padding: 16px;font-family: SFMono-Regular, Consolas, &amp;quot;font-size: 13.6px;line-height: 1.45;background-color: rgb(246, 248, 250);color: rgb(36, 41, 46);font-style: normal;font-weight: 400;letter-spacing: normal;text-align: start;text-indent: 0px;text-transform: none;word-spacing: 0px"><CODE style="margin: 0px;padding: 0px;font-family: SFMono-Regular, Consolas, &amp;quot;font-size: 13.6px;background: transparent;white-space: pre;border: 0px;line-height: inherit">feat(lang): add polish language</CODE></PRE>
## Thông báo commit về việc fix một (tùy chọn) task
<PRE style="margin: 0px 0px 16px;padding: 16px;font-family: SFMono-Regular, Consolas, &amp;quot;font-size: 13.6px;line-height: 1.45;background-color: rgb(246, 248, 250);color: rgb(36, 41, 46);font-style: normal;font-weight: 400;letter-spacing: normal;text-align: start;text-indent: 0px;text-transform: none;word-spacing: 0px"><CODE style="margin: 0px;padding: 0px;font-family: SFMono-Regular, Consolas, &amp;quot;font-size: 13.6px;background: transparent;white-space: pre;border: 0px;line-height: inherit">fix: correct minor typos in code

see the issue for details on the typos fixed

closes issue #12</CODE></PRE>
## IV. Các quy tắc 
1. Đặt tên thông báo bằng tiếng việt
2. Commit cần có tiền tố là nhãn commit: feat, fix, theo sau là một **TÙY CHỌN** phạm vi, và một dấu ":" và một space.
3. Nhãn **feat** phải được sử dụng khi một commit thêm một chức năng.
4. Nhãn **fix** phải được sử dụng để đại diện cho một bug fix.
5. Một phạm vi có thể có hoặc không (ngay sau nhãn), phạm vi phải bao gồm một danh từ mô tả một phần của codebase và được bao bởi "()", ví dụ: "fix(parser):"
6. Một mô tả phải có 1 space sau tiền tố nhãn/phạm vi. Mô tả là một mô tả ngắn của các thay đổi trong codebase, ví dụ: _fix: array parsing issue when multiple spaces were contained in string._
7. Nội dung của commit có thể kéo dài sau mô tả ngắn, cung cấp các thông tin thêm về các thay đổi code. Nội dung phải được chia cắt với mô tả ngắn ngay trước bằng một dòng trống.
8. Những thay đổi lớn phải được chỉ ra tại phần thân nội dung thông báo, hoặc tại nơi bắt đầu của một dòng trong phần footer. Một thay đổi lớn phải bao gồm nhãn **BREAKING CHANGE**, theo sau bởi dấu ":" và một space.
9. Một dấu "!" có thể thêm ngay trước dấu ":" và ngay sau tiền tố nhãn/phạm vi, để nhấn mạnh về những thay đổi codebase.
