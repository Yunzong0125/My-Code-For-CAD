# 长方体生成器 - 基础版本
def create_cuboid
  # 获取当前模型
  model = Sketchup.active_model
  entities = model.entities
  
  # 开始操作（支持撤销）
  model.start_operation("创建立方体")
  
  # 获取用户输入
  prompts = ["长度:", "宽度:", "高度:"]
  defaults = ["100.cm", "50.cm", "30.cm"]
  input = UI.inputbox(prompts, defaults, "创建立方体")
  
  # 检查用户是否取消
  return if input.nil?
  
  # 解析输入值（支持带单位或不带单位）
  length = input[0].to_l
  width = input[1].to_l
  height = input[2].to_l
  
  # 以原点(0,0,0)为起点
  origin = Geom::Point3d.new(0, 0, 0)
  
  # 创建底面矩形
  points = [
    origin,
    origin + Geom::Vector3d.new(length, 0, 0),
    origin + Geom::Vector3d.new(length, width, 0),
    origin + Geom::Vector3d.new(0, width, 0)
  ]
  
  # 绘制底面
  face = entities.add_face(points)
  
  # 推拉形成长方体
  face.pushpull(height)
  
  # 完成操作
  model.commit_operation
  
  # 缩放视图以显示全部
  Sketchup.active_model.active_view.zoom_extents
  
  # 显示结果
  UI.messagebox("成功创建立方体！\n尺寸: #{length} × #{width} × #{height}")
end

# 添加到菜单
if (!file_loaded?(__FILE__))
  menu = UI.menu("插件")
  menu.add_item("创建立方体") { create_cuboid }
end

file_loaded(__FILE__)