# ros2-nvim
The most fluid ros2 NeoVim plugin to date!

## Demo
![](https://github.com/DragonflyRobotics/ros2-nvim/blob/main/demo/plugin_demo.gif)

## Installation

Installation is extremely simple.

### Lazy
```json
"DragonflyRobotics/ros2-nvim"
```

### Packer
```lua
use 'DragonflyRobotics/ros2-nvim'
```

### Vim-Plug
```vim
Plug 'DragonflyRobotics/ros2-nvim'
```

### Manual (Not Recommended)
```bash
git clone https://github.com/DragonflyRobotics/ros2-nvim 
cd ros2-nvim
cp -r * ~/.config/nvim/
```

## Features
- [x] Telescope Integration
- [x] ROS2 Topic Info
- [x] ROS2 Topic Echo
- [ ] ROS2 Command Execution (Coming Soon)
- [ ] ROS2 Service Info (Coming Soon)
- [ ] ROS2 Service Call (Coming Soon)
- [ ] ROS2 Node Info (Coming Soon)
- [ ] ROS2 Node Kill (Coming Soon)
- [ ] ROS2 Node Launch (Coming Soon)


## Usage
 - `Telescope ros2-nvim topics_telescope` - List all topics
