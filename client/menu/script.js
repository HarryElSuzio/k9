const app = new Vue({
  el: "#app",
  data: {
    resourcename: "k9",
    visible: false,
    menu: "K9",
    buttons: [],
    selectedButton: 0
  },
  methods: {
    SetResourceName(data) {
      this.resourcename = data.resource;
    },
    ShowMenu() {
      this.visible = true;
    },
    HideMenu() {
      this.visible = false;
    },
    ChangeMenu(data) {
      this.menu = data.name;
      this.buttons = data.buttons
    },
    SetSelectedButton(data) {
      console.log(`button: ${data.button}`);
      this.selectedButton = data.button
    },
  },

  // EVENTS
  mounted() {
    RegisterEvent("set_resource_name", this.SetResourceName);
    RegisterEvent("show_menu", this.ShowMenu);
    RegisterEvent("hide_menu", this.HideMenu);
    RegisterEvent("change_menu", this.ChangeMenu);
    RegisterEvent("set_selected_button", this.SetSelectedButton);
  }
})
