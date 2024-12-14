// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import { initPagy } from "@pagy/extras/turbo";

document.addEventListener("turbo:load", () => {
    initPagy();
});