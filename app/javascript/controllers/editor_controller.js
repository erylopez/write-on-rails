import { Controller } from "@hotwired/stimulus"
import Prism from 'prismjs';
import '../prism-languages';
import codeSyntaxHighlight from '@toast-ui/editor-plugin-code-syntax-highlight';
import Viewer from '@toast-ui/editor/dist/toastui-editor-viewer';
import Editor from '@toast-ui/editor';

export default class extends Controller {
  static targets = ["field"]

  onChange() {
    this.fieldTarget.value = this.editor.getMarkdown();
  }

  connect() {
    this.editor = new Editor({
      el: document.getElementById('editor'),
      previewStyle: 'vertical',
      height: '500px',
      initialEditType: 'markdown',
      initialValue: '```ruby\ndef something\n  return true\nend\n```',
      events: {
        change: this.onChange.bind(this)
      },
      plugins: [[codeSyntaxHighlight, { highlighter: Prism }]]
    });

    const viewer = new Viewer({
      el: document.querySelector('#viewer'),
      height: '600px',
      initialValue: '# Demo\n```ruby\ndef something\n  return true\nend\n```',
      plugins: [[codeSyntaxHighlight, { highlighter: Prism }]]
    });
  }
}