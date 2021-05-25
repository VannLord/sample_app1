import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
require("jquery")
import "bootstrap"
import I18n from "i18n-js"
window.I18n = I18n
Rails.start()
Turbolinks.start()
ActiveStorage.start()


