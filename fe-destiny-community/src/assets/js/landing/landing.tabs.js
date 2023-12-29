import { app } from "../utils/app.js";

export const tabs = {
  tabs: function () {
    app.plugins.createTab({
      triggers: ".login-register-form-trigger",
      elements: ".login-register-form-element",
      animation: {
        type: "slide-in-right",
      },
      onTabChange: function (activeTab) {
        const firstInput = activeTab.querySelector("input");

        firstInput.focus();
      },
    });
  },
};
