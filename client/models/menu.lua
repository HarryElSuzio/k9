Menu = {}
Menu.__index = Menu

function Menu.Create(title, description)
  local newMenu = {}
  setmetatable(newMenu, Menu)

  newMenu.Title = title
  newMenu.Type = "menu"
  newMenu.Description = description or ""
  newMenu.Components = {}
  newMenu.Hovered = 1
  newMenu.Opened = false
  newMenu.OpenedMenu = newMenu

  function newMenu:OpenMenu()
    local menuComps = {}

    for k, v in pairs(self.Components) do
      menuComps[k] = {
        Title = v.Title,
        Type = v.Type,
        Description = v.Description
      }
    end

    NUI.Fire("change_menu", { 
      title = self.Title,
      components =  menuComps
    })
    NUI.Fire("show_menu")
    NUI.Fire("set_selected_component", {
      component = self.Hovered
    })
    self.Opened = true
    newMenu.OpenedMenu = self
  end

  function newMenu:GoUp()
    local next = self.Hovered - 1

    if next < 1 then
      next = #self.Components
    end

    self.Hovered = next
    NUI.Fire("set_selected_component", {
      component = self.Hovered
    })
  end

  function newMenu:GoDown()
    local next = self.Hovered + 1

    if next > #self.Components then
      next = 1
    end

    self.Hovered = next
    NUI.Fire("set_selected_component", {
      component = self.Hovered
    })
  end

  function newMenu:GoBack()
    self.Opened = false
    self.OpenedMenu = self
    self.Hovered = 1
    NUI.Fire("hide_menu")
  end

  function newMenu:FireComponent()
    local comp = self.Components[self.Hovered]
    if comp then
      if comp.Type == "submenu" then
        comp:OpenMenu()
      elseif comp.Type == "button" then
        comp:Fire()
      end
    else
      print("No component selected")
    end
  end

  return newMenu
end

function Menu.CreateSubMenu(title, parent, base, description)
  local newMenu = {}

  newMenu.Title = title
  newMenu.Type = "submenu"
  newMenu.Description = description or ""
  newMenu.Components = {}
  newMenu.Hovered = 1
  newMenu.Opened = false
  newMenu.Parent = parent

  function newMenu:OpenMenu()
    local menuComps = {}

    for k, v in pairs(self.Components) do
      menuComps[k] = {
        Title = v.Title,
        Type = v.Type,
        Description = v.Description
      }
    end

    NUI.Fire("change_menu", { 
      title = self.Title,
      components =  menuComps
    })
    NUI.Fire("show_menu")
    NUI.Fire("set_selected_component", {
      component = self.Hovered
    })
    self.Opened = true
    base.OpenedMenu = self
    print()
  end

  function newMenu:GoUp()
    local next = self.Hovered - 1

    if next < 1 then
      next = #self.Components
    end

    self.Hovered = next
    NUI.Fire("set_selected_component", {
      component = self.Hovered
    })
  end

  function newMenu:GoDown()
    local next = self.Hovered + 1

    if next > #self.Components then
      next = 1
    end

    self.Hovered = next
    NUI.Fire("set_selected_component", {
      component = self.Hovered
    })
  end

  function newMenu:GoBack()
    base.Opened = true
    base.OpenedMenu = parent
    self.Hovered = 1
    parent:OpenMenu()
  end

  function newMenu:FireComponent()
    local comp = self.Components[self.Hovered]
    if comp then
      if comp.Type == "submenu" then
        comp:OpenMenu()
      elseif comp.Type == "button" then
        comp:Fire()
      end
    else
      print("No component selected")
    end
  end

  table.insert(parent.Components, newMenu)
  return newMenu
end

function Menu.CreateButton(title, action, base, parent, description)
  local newButton = {}

  newButton.Title = title
  newButton.Type = "button"
  newButton.Description = description or ""
  newButton.Action = action
  newButton.Parent = parent

  function newButton:Fire()
    action()
  end

  table.insert(parent.Components, newButton)
  return newButton
end