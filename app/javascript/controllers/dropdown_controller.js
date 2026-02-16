import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  connect() {
    // Close on outside click
    this._outsideClickHandler = this._handleOutsideClick.bind(this)
    document.addEventListener("click", this._outsideClickHandler)
  }

  disconnect() {
    document.removeEventListener("click", this._outsideClickHandler)
  }

  toggle(event) {
    event.stopPropagation()
    const menu = this.menuTarget
    if (menu.style.display === "none" || !menu.style.display) {
      menu.style.display = "block"
    } else {
      menu.style.display = "none"
    }
  }

  _handleOutsideClick(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.style.display = "none"
    }
  }
}
