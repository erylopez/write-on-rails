import { Controller } from "@hotwired/stimulus"
import Prism from 'prismjs';
import '../prism-languages';
import codeSyntaxHighlight from '@toast-ui/editor-plugin-code-syntax-highlight';

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
      initialValue: this.fieldTarget.value,
      events: {
        change: this.onChange.bind(this)
      },
      plugins: [[codeSyntaxHighlight, { highlighter: Prism }]]
    });
  }
}