import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { delay: { type: Number, default: 3000 } }

  connect() {
    requestAnimationFrame(() => this.element.classList.remove("translate-x-full", "opacity-0"))
    this.timeout = setTimeout(() => this.dismiss(), this.delayValue)
  }

  disconnect() {
    clearTimeout(this.timeout)
  }

  dismiss() {
    this.element.classList.add("translate-x-full", "opacity-0")
    setTimeout(() => this.element.remove(), 300)
  }
}
