import { Controller } from "@hotwired/stimulus"
import Viewer from '@toast-ui/editor/dist/toastui-editor-viewer';
import Prism from 'prismjs';
import '../prism-languages';
import codeSyntaxHighlight from '@toast-ui/editor-plugin-code-syntax-highlight';

export default class extends Controller {
  static targets = ["content"]

  connect() {
    const viewer = new Viewer({
      el: this.contentTarget,
      height: '600px',
      initialValue: this.contentTarget.innerHTML,
      plugins: [[codeSyntaxHighlight, { highlighter: Prism }]]
    });

  }
}
