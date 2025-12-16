# Godot Singleplayer Autobattler Practice project（像素自走棋练习）
A singleplayer autobattler practice project made in Godot 4.


# Note

## 小问题
- Node的tree_exited信号在reparent时也会发出，Godot源码中reparent会先对旧父节点执行`data.parent->remove_child(this);`，再执行`p_parent->add_child(this);`，而前者在移除孩子的时候判断当前节点如果在场景树里会发出离开树信号`if (data.tree)  p_child->_propagate_after_exit_tree();`
- 针对固定大小数组可以采用优化的数据结构`PackedXXXArray`例如`PackedFloat32Array`
- `RandomNumberGenerator`是专门用于生成伪随机的类，支持种子和状态，支持加权随机生成。
- 信号可以通过bind和unbind自由捆绑回调方，例如`unit.drag_and_drop.dropped.connect(_on_unit_dropped.bind(unit).unbind(1))`，此例中，先丢弃信号传来的最后一个参数，随后绑定了一个回调方需要的额外参数
- Container通过手动设置size后会缓存这个大小，当内部元素hide的时候也不会收缩，如果你需要它收缩，应确保没有设置过，或者每次调整子节点隐藏时主动设置container大小

# Credits
- [from repository](https://github.com/guladam/godot_autobattler_course/tree/main)
- [ko-fi](https://ko-fi.com/M4M0RXV24)
- [32rogues asset pack by Seth](https://sethbb.itch.io/32rogues)
- [Kenney](https://kenney.nl/assets/cursor-pixel-pack)'s cursor pixel pack
- Sound effects are from the [Soniss GDC 2024 Game Audio Bundle](https://gdc.sonniss.com/)
- [StarNinjas](https://opengameart.org/users/starninjas) (sound effects)
- [remaxim](https://opengameart.org/users/remaxim) (sound effects)
- Music made by [Alexander Ehlers](https://opengameart.org/users/tricksntraps)
- [m5x7 font](https://managore.itch.io/m5x7) by Daniel Linssen
- [Abaddon font](https://caffinate.itch.io/abaddon) by Nathan Scott
