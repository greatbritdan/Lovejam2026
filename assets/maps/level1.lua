return {
  version = "1.10",
  luaversion = "5.1",
  tiledversion = "1.11.2",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 122,
  height = 16,
  tilewidth = 16,
  tileheight = 16,
  nextlayerid = 9,
  nextobjectid = 78,
  properties = {},
  tilesets = {
    {
      name = "Chess",
      firstgid = 1,
      filename = "../tilesets/Chess.tsx",
      exportfilename = "../tilesets/Chess.lua"
    }
  },
  layers = {
    {
      type = "group",
      id = 5,
      name = "Background",
      class = "",
      visible = true,
      opacity = 0.2,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      layers = {
        {
          type = "imagelayer",
          image = "../backgrounds/Chess3.png",
          id = 6,
          name = "Background3",
          class = "background3",
          visible = true,
          opacity = 1,
          offsetx = 0,
          offsety = 0,
          parallaxx = 0.25,
          parallaxy = 1,
          repeatx = true,
          repeaty = false,
          properties = {}
        },
        {
          type = "imagelayer",
          image = "../backgrounds/Chess2.png",
          id = 8,
          name = "Background2",
          class = "background2",
          visible = true,
          opacity = 1,
          offsetx = 0,
          offsety = 0,
          parallaxx = 0.5,
          parallaxy = 1,
          repeatx = true,
          repeaty = false,
          properties = {}
        },
        {
          type = "imagelayer",
          image = "../backgrounds/Chess1.png",
          id = 7,
          name = "Background1",
          class = "background1",
          visible = true,
          opacity = 1,
          offsetx = 0,
          offsety = 0,
          parallaxx = 0.75,
          parallaxy = 1,
          repeatx = true,
          repeaty = false,
          properties = {}
        }
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 122,
      height = 16,
      id = 3,
      name = "Tiles (Background)",
      class = "tilesback",
      visible = true,
      opacity = 0.5,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 81, 82, 81, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 104, 0, 0, 0, 82, 0, 0, 0, 0, 81, 0, 0, 0, 82, 81, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 81, 0, 0, 0, 0, 0, 0, 0, 0, 82, 0, 0, 0, 82, 0, 82, 81, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 82, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 81, 82, 81, 0, 0, 0, 0, 0, 0, 0, 82, 0, 0, 81, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 92, 0, 0, 0, 0, 0, 0, 0, 0, 0, 84, 81, 82, 0, 0, 0, 81, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 82, 81, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 81, 0, 0, 0, 0, 0, 81, 82, 81, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 82, 0, 0, 0, 0, 82, 81, 82, 81, 0, 0, 0, 130, 0, 0, 0, 0, 81, 0, 0, 0, 0, 0, 81, 0, 81, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 108, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 82, 81, 82, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 82, 81, 82, 99, 100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 81, 82, 99, 100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 82, 0, 0, 0, 0, 81, 82, 81, 82, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 81, 0, 0, 81, 82, 99, 100, 81, 82, 81, 0, 0, 0, 0, 113, 0, 0, 0, 81, 101, 102, 82, 81, 82, 81, 0, 0, 0, 0, 0, 145, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 81, 82, 83, 84, 81, 0, 0, 0, 0, 0, 0, 0, 82, 0, 0, 0, 0, 0, 89, 0, 82, 81, 83, 84, 82, 81, 82, 0, 0, 0, 0, 0, 82, 0, 0, 0, 0, 0, 0, 81, 82, 81, 85, 86, 0, 0, 82, 81, 0, 81, 0, 0, 81, 0, 0, 106, 81, 82, 83, 84, 81, 82, 81, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 83, 84, 82, 81, 83, 84, 103, 0, 0, 0, 0, 146, 0, 0, 0, 0, 83, 84, 81, 0, 81, 130, 0, 0, 0, 0, 0, 146, 0, 103, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 82, 81, 99, 100, 82, 0, 0, 0, 0, 0, 0, 0, 81, 0, 0, 0, 0, 0, 105, 0, 0, 82, 99, 100, 81, 82, 0, 0, 92, 0, 0, 0, 81, 0, 0, 0, 90, 0, 0, 82, 81, 82, 101, 102, 0, 0, 81, 0, 0, 103, 0, 0, 0, 0, 0, 145, 0, 81, 99, 100, 82, 81, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 81, 0, 0, 99, 100, 81, 82, 99, 100, 81, 0, 0, 0, 91, 129, 0, 0, 0, 81, 99, 100, 0, 0, 0, 129, 0, 0, 0, 0, 0, 145, 0, 145, 91, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 87, 0, 81, 82, 83, 84, 81, 82, 81, 82, 81, 0, 0, 0, 129, 0, 82, 0, 0, 0, 0, 0, 114, 0, 82, 81, 85, 86, 83, 84, 82, 0, 108, 0, 0, 0, 82, 0, 0, 0, 106, 0, 0, 88, 85, 86, 83, 84, 82, 81, 0, 0, 0, 129, 0, 0, 0, 0, 0, 114, 81, 82, 85, 86, 83, 84, 81, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 82, 0, 0, 82, 81, 83, 84, 82, 81, 0, 0, 0, 0, 107, 114, 0, 0, 81, 82, 85, 86, 81, 103, 0, 114, 0, 0, 0, 0, 0, 146, 0, 130, 107, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 130, 0, 0, 81, 99, 100, 82, 81, 82, 81, 0, 0, 104, 0, 146, 0, 81, 0, 0, 0, 0, 0, 129, 0, 0, 82, 101, 102, 99, 100, 0, 0, 145, 0, 0, 0, 81, 0, 0, 0, 145, 0, 0, 82, 101, 102, 99, 100, 81, 82, 81, 0, 0, 146, 113, 92, 0, 0, 0, 81, 82, 81, 101, 102, 99, 100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 87, 0, 0, 81, 0, 0, 81, 82, 99, 100, 81, 82, 81, 0, 0, 0, 82, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 113, 0, 0, 0, 0, 0, 145, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 145, 91, 81, 82, 85, 86, 83, 84, 81, 82, 81, 0, 113, 0, 145, 0, 0, 0, 0, 0, 0, 0, 114, 0, 82, 81, 83, 84, 85, 86, 82, 0, 130, 0, 0, 0, 0, 0, 0, 0, 146, 0, 0, 0, 83, 84, 85, 86, 83, 84, 0, 0, 0, 129, 114, 108, 0, 0, 81, 82, 85, 86, 83, 84, 81, 82, 81, 0, 0, 0, 0, 0, 0, 91, 129, 0, 0, 130, 0, 82, 0, 0, 0, 81, 85, 86, 83, 84, 87, 0, 0, 0, 81, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 82, 0, 0, 0, 146, 107, 82, 81, 101, 102, 99, 100, 82, 81, 82, 81, 146, 0, 146, 0, 0, 0, 0, 0, 87, 0, 113, 82, 81, 82, 99, 100, 101, 102, 81, 82, 113, 0, 0, 0, 0, 0, 0, 0, 129, 0, 0, 82, 99, 100, 101, 102, 99, 100, 81, 0, 0, 0, 0, 0, 0, 0, 0, 81, 101, 102, 99, 100, 82, 81, 103, 0, 0, 145, 0, 0, 0, 107, 146, 0, 0, 129, 0, 0, 0, 0, 92, 0, 101, 102, 99, 100, 81, 0, 0, 0, 82, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 88, 0, 0, 0, 82, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 145, 82, 81, 82, 83, 84, 85, 86, 83, 84, 81, 82, 81, 0, 129, 0, 89, 0, 0, 0, 130, 0, 82, 81, 83, 84, 85, 86, 83, 84, 82, 81, 82, 0, 82, 0, 0, 0, 0, 0, 114, 0, 82, 81, 85, 86, 83, 84, 82, 81, 82, 81, 0, 0, 0, 0, 0, 0, 0, 82, 83, 84, 85, 86, 83, 84, 81, 0, 0, 130, 0, 0, 113, 130, 113, 0, 0, 114, 0, 0, 0, 0, 108, 81, 83, 84, 85, 86, 82, 81, 0, 0, 0, 114, 0, 0, 0, 0, 0, 82, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 82, 81, 82, 81, 99, 100, 101, 102, 99, 100, 82, 81, 82, 81, 114, 81, 105, 0, 0, 103, 113, 0, 0, 0, 0, 0, 101, 102, 99, 100, 81, 82, 81, 82, 81, 82, 87, 0, 81, 0, 81, 82, 81, 82, 101, 102, 99, 100, 81, 82, 81, 82, 0, 0, 82, 0, 0, 0, 0, 0, 99, 100, 101, 102, 99, 100, 82, 81, 0, 145, 0, 0, 146, 145, 114, 0, 0, 145, 0, 90, 0, 0, 81, 82, 99, 100, 101, 102, 81, 82, 81, 0, 0, 129, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 81, 0, 81, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 83, 84, 85, 86, 83, 84, 85, 86, 81, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 82, 81, 82, 81, 83, 84, 82, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 85, 86, 83, 84, 81, 82, 81, 82, 81, 146, 81, 0, 129, 130, 129, 88, 0, 130, 0, 106, 0, 81, 82, 81, 85, 86, 83, 84, 82, 81, 82, 81, 0, 114, 88, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 82, 83, 84, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 81, 0, 0, 0, 0, 0, 0, 0, 0, 0, 102, 99, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 81, 99, 100, 0, 81, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 85, 86, 0, 0, 0, 82, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 83, 84, 85, 0, 0, 82, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 81, 0, 0, 0, 0, 0, 0, 0, 0, 0, 81, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 81, 0, 0, 0, 0, 0, 0, 0, 0, 0, 85, 86, 0, 84, 85, 86, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 99, 100, 101, 102, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 99, 100, 101, 102, 0, 0, 0, 0, 0, 0, 0, 0, 0, 81, 0, 0, 0, 0, 0, 0, 0, 81, 0, 0, 0, 0, 0, 0, 82, 81, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 81, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 81, 0, 0, 0, 0, 82, 81, 0, 0, 0, 0, 0, 0, 0, 0, 101, 102, 0, 100, 101, 102, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 85, 86, 83, 84, 85, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 84, 85, 86, 83, 84, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 82, 0, 0, 0, 0, 0, 0, 0, 82, 81, 82, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 81, 0, 0, 0, 0, 0, 0, 82, 81, 82, 81, 0, 0, 0, 0, 0, 0, 0, 83, 84, 0, 86, 83, 84, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 122,
      height = 16,
      id = 4,
      name = "Tiles",
      class = "tiles",
      visible = true,
      opacity = 0.9,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 34, 0, 0, 1, 21, 22, 19, 20, 2, 0, 0, 0, 1, 2, 19, 20, 21, 22, 19, 20, 1, 2, 19, 20, 0, 0, 1, 0, 0, 0, 1, 2, 1, 2, 24, 2, 19, 20, 0, 52, 19, 20, 21, 22, 19, 20, 2, 1, 2, 1, 2, 24, 19, 20, 2, 1, 19, 20, 21, 22, 68, 1, 2, 1, 8, 1, 0, 0, 19, 20, 21, 22, 19, 20, 21, 22, 19, 20, 8, 1, 19, 20, 2, 1, 19, 20, 21, 22, 19, 20, 1, 2, 0, 0, 0, 0, 0, 1, 2, 1, 2, 1, 68, 1, 2, 24, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 51, 34, 0,
        0, 0, 65, 0, 51, 2, 3, 4, 5, 6, 1, 0, 0, 0, 2, 1, 2, 24, 3, 4, 5, 6, 3, 4, 2, 1, 2, 1, 2, 0, 0, 0, 0, 0, 2, 1, 2, 1, 5, 6, 3, 4, 2, 1, 3, 4, 1, 2, 1, 2, 1, 2, 3, 4, 5, 6, 3, 4, 5, 6, 3, 4, 67, 2, 1, 2, 1, 2, 0, 0, 0, 2, 3, 4, 5, 6, 3, 4, 5, 6, 3, 4, 1, 2, 1, 2, 1, 8, 1, 2, 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 67, 2, 1, 2, 1, 2, 0, 0, 0, 0, 0, 2, 1, 2, 1, 2, 49, 52,
        52, 0, 66, 0, 2, 1, 19, 20, 21, 22, 2, 0, 0, 0, 0, 2, 1, 2, 19, 20, 21, 22, 19, 20, 1, 2, 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 21, 22, 19, 20, 1, 8, 19, 20, 2, 0, 0, 0, 0, 0, 19, 20, 21, 22, 19, 20, 21, 22, 19, 20, 68, 1, 2, 1, 2, 0, 0, 0, 0, 1, 19, 20, 21, 22, 19, 20, 21, 22, 19, 20, 2, 1, 2, 24, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 1, 2, 1,
        3, 4, 49, 52, 1, 2, 1, 2, 1, 2, 0, 0, 0, 0, 0, 1, 2, 1, 0, 0, 3, 4, 68, 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 1, 68, 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 4, 0, 0, 0, 0, 0, 2, 67, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 3, 4, 1, 2, 1, 0, 0, 0, 0, 2, 1, 2, 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4,
        19, 20, 2, 1, 2, 49, 0, 0, 2, 1, 0, 0, 0, 0, 0, 2, 1, 0, 0, 0, 19, 20, 67, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 67, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 19, 20, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 19, 20, 2, 0, 0, 0, 0, 0, 0, 0, 2, 67, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 19, 20,
        1, 2, 1, 2, 1, 66, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 68, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 68, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 1, 0, 0, 0, 0, 0, 0, 0, 1, 68, 1, 2, 17, 18, 17, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 1, 2,
        2, 1, 2, 1, 0, 33, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 67, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 67, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 2, 67, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 68, 1, 69, 70, 2, 1, 2, 1, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 1, 2, 1,
        3, 4, 1, 2, 0, 34, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 17, 18, 17, 18, 1, 68, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 67, 2, 1, 2, 1, 2, 3, 4, 1, 2, 1, 2, 17, 0, 0, 0, 17, 2, 1, 2, 1, 2, 3, 4,
        19, 20, 8, 1, 0, 49, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 1, 2, 1, 2, 1, 2, 0, 0, 0, 18, 17, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 18, 17, 0, 0, 68, 1, 2, 1, 2, 1, 19, 20, 2, 1, 2, 1, 0, 0, 0, 0, 0, 1, 2, 1, 8, 1, 19, 20,
        5, 6, 3, 4, 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 4, 1, 2, 1, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 17, 18, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 33, 2, 1, 8, 3, 4, 1, 2, 1, 0, 0, 0, 3, 4, 1, 2, 3, 4, 5, 6,
        21, 22, 19, 20, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 1, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 19, 20, 8, 1, 2, 1, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 18, 17, 0, 0, 0, 0, 0, 0, 34, 1, 2, 1, 19, 20, 2, 1, 2, 0, 0, 0, 19, 20, 2, 1, 19, 20, 21, 22,
        3, 4, 5, 6, 3, 4, 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 1, 2, 3, 4, 5, 6, 3, 4, 1, 2, 1, 2, 1, 2, 3, 4, 5, 6, 69, 70, 5, 6, 3, 4, 1, 2, 1, 2, 0, 0, 0, 0, 0, 0, 0, 2, 1, 2, 3, 4, 5, 6, 3, 4, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 65, 2, 3, 4, 5, 6, 3, 4, 1, 0, 0, 0, 1, 2, 3, 4, 5, 6, 3, 4,
        19, 20, 21, 22, 19, 20, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 24, 19, 20, 21, 22, 19, 20, 2, 1, 2, 0, 50, 1, 19, 20, 21, 22, 1, 2, 21, 22, 19, 20, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 19, 20, 21, 22, 19, 20, 2, 1, 19, 20, 2, 1, 2, 1, 2, 69, 70, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 69, 70, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 19, 20, 21, 22, 19, 20, 2, 0, 0, 0, 2, 24, 19, 20, 21, 22, 19, 20,
        5, 6, 3, 4, 5, 6, 3, 4, 1, 2, 1, 2, 0, 66, 3, 4, 1, 8, 3, 4, 5, 6, 3, 4, 1, 2, 3, 4, 33, 0, 33, 2, 1, 8, 3, 4, 5, 6, 3, 4, 1, 2, 3, 4, 1, 2, 1, 2, 1, 2, 3, 4, 5, 6, 3, 4, 49, 2, 3, 4, 1, 2, 1, 2, 1, 2, 24, 2, 1, 2, 3, 4, 5, 6, 3, 4, 5, 6, 3, 4, 1, 2, 1, 2, 1, 2, 3, 4, 5, 6, 3, 4, 1, 2, 1, 2, 1, 2, 33, 0, 1, 2, 3, 4, 5, 6, 3, 4, 65, 36, 1, 0, 0, 0, 3, 4, 5, 6, 3, 4, 5, 6,
        21, 22, 19, 20, 21, 22, 19, 20, 2, 1, 0, 33, 0, 65, 19, 20, 2, 1, 19, 20, 21, 22, 19, 20, 2, 1, 19, 20, 50, 0, 66, 0, 2, 1, 19, 20, 21, 22, 19, 20, 2, 24, 19, 20, 2, 1, 2, 1, 2, 24, 19, 20, 21, 22, 19, 20, 66, 0, 19, 20, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 19, 20, 21, 22, 19, 20, 21, 22, 19, 20, 2, 24, 2, 1, 2, 1, 19, 20, 21, 22, 19, 20, 2, 24, 2, 1, 2, 1, 50, 0, 0, 1, 19, 20, 21, 22, 19, 20, 34, 0, 2, 0, 0, 0, 19, 20, 21, 22, 19, 20, 21, 22,
        3, 4, 1, 2, 3, 4, 1, 2, 3, 4, 0, 66, 0, 66, 0, 2, 3, 4, 5, 6, 3, 4, 1, 2, 3, 4, 1, 0, 65, 0, 65, 0, 1, 2, 1, 2, 3, 4, 1, 2, 1, 2, 1, 2, 1, 2, 1, 8, 3, 4, 1, 2, 3, 4, 1, 0, 65, 0, 5, 6, 3, 4, 1, 2, 1, 2, 1, 2, 3, 4, 1, 2, 3, 4, 5, 6, 3, 4, 1, 2, 1, 2, 1, 2, 3, 4, 5, 6, 3, 4, 24, 2, 3, 4, 5, 6, 1, 36, 65, 0, 51, 2, 1, 2, 3, 4, 5, 6, 49, 0, 1, 0, 0, 0, 1, 2, 3, 4, 5, 6, 3, 4
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 2,
      name = "Objects",
      class = "objects",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 2,
          name = "",
          type = "player",
          shape = "rectangle",
          x = 194,
          y = -4,
          width = 12,
          height = 4,
          rotation = 0,
          visible = true,
          properties = {
            ["counters"] = 0
          }
        },
        {
          id = 19,
          name = "",
          type = "text",
          shape = "point",
          x = 200,
          y = 140,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["linkid"] = 2,
            ["text"] = "press a or d to move"
          }
        },
        {
          id = 20,
          name = "",
          type = "text",
          shape = "point",
          x = 200,
          y = 148,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["linkid"] = 2,
            ["text"] = "press space to jump!"
          }
        },
        {
          id = 21,
          name = "",
          type = "trigger",
          shape = "rectangle",
          x = 311,
          y = 49,
          width = 2,
          height = 127,
          rotation = 0,
          visible = true,
          properties = {
            ["linkid"] = 1,
            ["mode"] = "on"
          }
        },
        {
          id = 22,
          name = "",
          type = "door",
          shape = "rectangle",
          x = 357,
          y = 112,
          width = 5.81818,
          height = 64,
          rotation = 0,
          visible = true,
          properties = {
            ["dist"] = 64,
            ["linkid"] = 1
          }
        },
        {
          id = 23,
          name = "",
          type = "counter",
          shape = "rectangle",
          x = 466,
          y = 156,
          width = 12,
          height = 4,
          rotation = 0,
          visible = true,
          properties = {
            ["counters"] = 1
          }
        },
        {
          id = 25,
          name = "",
          type = "text",
          shape = "point",
          x = 472,
          y = 108,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["linkid"] = 3,
            ["text"] = "press e to merge with counters"
          }
        },
        {
          id = 26,
          name = "",
          type = "text",
          shape = "point",
          x = 472,
          y = 116,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["linkid"] = 3,
            ["text"] = "make sure you stand on top."
          }
        },
        {
          id = 27,
          name = "",
          type = "switch",
          shape = "rectangle",
          x = 576,
          y = 176,
          width = 32,
          height = 9,
          rotation = 0,
          visible = true,
          properties = {
            ["counters"] = 1,
            ["linkid"] = 4
          }
        },
        {
          id = 28,
          name = "",
          type = "door",
          shape = "rectangle",
          x = 677,
          y = 112,
          width = 5.81818,
          height = 64,
          rotation = 0,
          visible = true,
          properties = {
            ["dist"] = 64,
            ["linkid"] = 4
          }
        },
        {
          id = 29,
          name = "",
          type = "text",
          shape = "point",
          x = 592,
          y = 124,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["linkid"] = 3,
            ["text"] = "press q to split"
          }
        },
        {
          id = 30,
          name = "",
          type = "text",
          shape = "point",
          x = 592,
          y = 132,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["linkid"] = 3,
            ["text"] = "switches require counters to trigger-"
          }
        },
        {
          id = 32,
          name = "",
          type = "trigger",
          shape = "rectangle",
          x = 311,
          y = 48,
          width = 2,
          height = 128,
          rotation = 0,
          visible = true,
          properties = {
            ["linkid"] = 2,
            ["mode"] = "on"
          }
        },
        {
          id = 33,
          name = "",
          type = "trigger",
          shape = "rectangle",
          x = 375,
          y = 112,
          width = 2.03175,
          height = 64,
          rotation = 0,
          visible = true,
          properties = {
            ["linkid"] = 1,
            ["mode"] = "off"
          }
        },
        {
          id = 34,
          name = "",
          type = "trigger",
          shape = "rectangle",
          x = 695,
          y = 112,
          width = 2,
          height = 64,
          rotation = 0,
          visible = true,
          properties = {
            ["linkid"] = 3,
            ["mode"] = "on"
          }
        },
        {
          id = 36,
          name = "",
          type = "trigger",
          shape = "rectangle",
          x = 695,
          y = 113,
          width = 2.03175,
          height = 63,
          rotation = 0,
          visible = true,
          properties = {
            ["linkid"] = 4,
            ["mode"] = "off"
          }
        },
        {
          id = 37,
          name = "",
          type = "counter",
          shape = "rectangle",
          x = 786,
          y = 188,
          width = 12,
          height = 4,
          rotation = 0,
          visible = true,
          properties = {
            ["counters"] = 4
          }
        },
        {
          id = 38,
          name = "",
          type = "text",
          shape = "point",
          x = 792,
          y = 140,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["linkid"] = 5,
            ["text"] = "you can use counters to climb by"
          }
        },
        {
          id = 39,
          name = "",
          type = "text",
          shape = "point",
          x = 792,
          y = 148,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["linkid"] = 5,
            ["text"] = "splitting and using them as platforms"
          }
        },
        {
          id = 40,
          name = "",
          type = "door",
          shape = "rectangle",
          x = 997,
          y = 64,
          width = 5.81818,
          height = 64,
          rotation = 0,
          visible = true,
          properties = {
            ["dist"] = 64,
            ["linkid"] = 6
          }
        },
        {
          id = 41,
          name = "",
          type = "trigger",
          shape = "rectangle",
          x = 951,
          y = 48,
          width = 2,
          height = 80,
          rotation = 0,
          visible = true,
          properties = {
            ["linkid"] = 5,
            ["mode"] = "on"
          }
        },
        {
          id = 42,
          name = "",
          type = "trigger",
          shape = "rectangle",
          x = 951,
          y = 49,
          width = 2,
          height = 79,
          rotation = 0,
          visible = true,
          properties = {
            ["linkid"] = 6,
            ["mode"] = "on"
          }
        },
        {
          id = 43,
          name = "",
          type = "trigger",
          shape = "rectangle",
          x = 1015,
          y = 64,
          width = 2,
          height = 64,
          rotation = 0,
          visible = true,
          properties = {
            ["linkid"] = 6,
            ["mode"] = "off"
          }
        },
        {
          id = 44,
          name = "",
          type = "counter",
          shape = "rectangle",
          x = 1098,
          y = 124,
          width = 12,
          height = 4,
          rotation = 0,
          visible = true,
          properties = {
            ["counters"] = 4
          }
        },
        {
          id = 45,
          name = "",
          type = "counter",
          shape = "rectangle",
          x = 1306,
          y = 108,
          width = 12,
          height = 4,
          rotation = 0,
          visible = true,
          properties = {
            ["counters"] = 4
          }
        },
        {
          id = 46,
          name = "",
          type = "switch",
          shape = "rectangle",
          x = 1136,
          y = 192,
          width = 32,
          height = 9,
          rotation = 0,
          visible = true,
          properties = {
            ["counters"] = 8,
            ["linkid"] = 7
          }
        },
        {
          id = 47,
          name = "",
          type = "door",
          shape = "rectangle",
          x = 1365,
          y = 128,
          width = 5.81818,
          height = 64,
          rotation = 0,
          visible = true,
          properties = {
            ["dist"] = 64,
            ["linkid"] = 7
          }
        },
        {
          id = 48,
          name = "",
          type = "trigger",
          shape = "rectangle",
          x = 1383,
          y = 128,
          width = 2.03175,
          height = 64,
          rotation = 0,
          visible = true,
          properties = {
            ["linkid"] = 7,
            ["mode"] = "off"
          }
        },
        {
          id = 49,
          name = "",
          type = "text",
          shape = "point",
          x = 1152,
          y = 160,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["linkid"] = 8,
            ["text"] = "some switches need more than 1 counter"
          }
        },
        {
          id = 50,
          name = "",
          type = "trigger",
          shape = "rectangle",
          x = 1383,
          y = 129,
          width = 2,
          height = 63,
          rotation = 0,
          visible = true,
          properties = {
            ["linkid"] = 8,
            ["mode"] = "on"
          }
        },
        {
          id = 51,
          name = "",
          type = "door",
          shape = "rectangle",
          x = 1669,
          y = 32,
          width = 5.81818,
          height = 64,
          rotation = 0,
          visible = true,
          properties = {
            ["dist"] = 64,
            ["linkid"] = 9
          }
        },
        {
          id = 52,
          name = "",
          type = "switch",
          shape = "rectangle",
          x = 1600,
          y = 96,
          width = 32,
          height = 9,
          rotation = 0,
          visible = true,
          properties = {
            ["counters"] = 8,
            ["linkid"] = 9
          }
        },
        {
          id = 53,
          name = "",
          type = "door",
          shape = "rectangle",
          x = 1573,
          y = 144,
          width = 5.81818,
          height = 48,
          rotation = 0,
          visible = true,
          properties = {
            ["dist"] = 48,
            ["linkid"] = 10
          }
        },
        {
          id = 54,
          name = "",
          type = "counter",
          shape = "rectangle",
          x = 1610,
          y = 188,
          width = 12,
          height = 4,
          rotation = 0,
          visible = true,
          properties = {
            ["counters"] = 2
          }
        },
        {
          id = 56,
          name = "",
          type = "counter",
          shape = "rectangle",
          x = 1610,
          y = 92,
          width = 12,
          height = 4,
          rotation = 0,
          visible = true,
          properties = {
            ["counters"] = 4
          }
        },
        {
          id = 58,
          name = "",
          type = "switch",
          shape = "rectangle",
          x = 1440,
          y = 192,
          width = 32,
          height = 9,
          rotation = 0,
          visible = true,
          properties = {
            ["counters"] = 6,
            ["linkid"] = 10
          }
        },
        {
          id = 59,
          name = "",
          type = "counter",
          shape = "rectangle",
          x = 1418,
          y = 76,
          width = 12,
          height = 4,
          rotation = 0,
          visible = true,
          properties = {
            ["counters"] = 2
          }
        },
        {
          id = 60,
          name = "",
          type = "text",
          shape = "point",
          x = 1616,
          y = 60,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["linkid"] = 11,
            ["text"] = "top tip!"
          }
        },
        {
          id = 61,
          name = "",
          type = "text",
          shape = "point",
          x = 1616,
          y = 68,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["linkid"] = 11,
            ["text"] = "counters can be pushed!"
          }
        },
        {
          id = 62,
          name = "",
          type = "trigger",
          shape = "rectangle",
          x = 1687,
          y = 32,
          width = 2,
          height = 64,
          rotation = 0,
          visible = true,
          properties = {
            ["linkid"] = 9,
            ["mode"] = "off"
          }
        },
        {
          id = 63,
          name = "",
          type = "trigger",
          shape = "rectangle",
          x = 1687,
          y = 33,
          width = 2,
          height = 63,
          rotation = 0,
          visible = true,
          properties = {
            ["linkid"] = 11,
            ["mode"] = "on"
          }
        },
        {
          id = 64,
          name = "",
          type = "text",
          shape = "point",
          x = 1800,
          y = 76,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["text"] = "jump down to the"
          }
        },
        {
          id = 65,
          name = "",
          type = "text",
          shape = "point",
          x = 1800,
          y = 84,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["text"] = "next level!"
          }
        },
        {
          id = 66,
          name = "",
          type = "trigger",
          shape = "rectangle",
          x = 384,
          y = 112,
          width = 16,
          height = 64,
          rotation = 0,
          visible = true,
          properties = {
            ["linkid"] = 101,
            ["mode"] = "on"
          }
        },
        {
          id = 68,
          name = "",
          type = "checkpoint",
          shape = "point",
          x = 392,
          y = 176,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["linkid"] = 101
          }
        },
        {
          id = 69,
          name = "",
          type = "trigger",
          shape = "rectangle",
          x = 704,
          y = 112,
          width = 16,
          height = 64,
          rotation = 0,
          visible = true,
          properties = {
            ["linkid"] = 102,
            ["mode"] = "on"
          }
        },
        {
          id = 70,
          name = "",
          type = "checkpoint",
          shape = "point",
          x = 712,
          y = 176,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["linkid"] = 102
          }
        },
        {
          id = 71,
          name = "",
          type = "trigger",
          shape = "rectangle",
          x = 1024,
          y = 64,
          width = 16,
          height = 64,
          rotation = 0,
          visible = true,
          properties = {
            ["linkid"] = 103,
            ["mode"] = "on"
          }
        },
        {
          id = 72,
          name = "",
          type = "checkpoint",
          shape = "point",
          x = 1032,
          y = 128,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["linkid"] = 103
          }
        },
        {
          id = 73,
          name = "",
          type = "trigger",
          shape = "rectangle",
          x = 1392,
          y = 128,
          width = 16,
          height = 64,
          rotation = 0,
          visible = true,
          properties = {
            ["linkid"] = 104,
            ["mode"] = "on"
          }
        },
        {
          id = 74,
          name = "",
          type = "checkpoint",
          shape = "point",
          x = 1400,
          y = 192,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["linkid"] = 104
          }
        },
        {
          id = 75,
          name = "",
          type = "trigger",
          shape = "rectangle",
          x = 1696,
          y = 32,
          width = 16,
          height = 64,
          rotation = 0,
          visible = true,
          properties = {
            ["linkid"] = 105,
            ["mode"] = "on"
          }
        },
        {
          id = 76,
          name = "",
          type = "checkpoint",
          shape = "point",
          x = 1704,
          y = 96,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["linkid"] = 105
          }
        }
      }
    }
  }
}
