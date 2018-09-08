using Random

# リストの要素(ノード)を表す構造体
mutable struct tagTreeNode
    left  # 左側のノード
    right # 右側のノード
    value::Int    # この要素が持っているデータ
    tagTreeNode() = new()
end

function createNewNode(num, node_list)
  node_new = tagTreeNode()

  # 新しいノードを作成して, 初期化する
  if node_new = nothing
    return false
  end
  node_new.left = nothing
  node_new.right = nothing
  node_new.value = num

  push!(node_list, node_new)

  return node_new
end

function insertTree(num, node, root_node, node_list)

  # １つも挿入されていない場合
  if node == nothing
    root_node = createNewNode(num)
    return
  end

  if node.value > num
  # numが現在のnodeの値よりも小さい場合

    if node.left != nothing
      insertTree(num,  node.left)
    else
      # 左側に追加する
      node.left = createNewNode(num, node_list)
    end
  else
  # numが現在のnodeの値位以上の場合
    if node.right != nothing
      insertTree(num, node.right)
    else
      # 右側に追加する
      node.right = createNewNode(num, node_list)
    end
  end

  return

end

function findValue(node, val)
  # 発見したtree_nodeのポインタを返す. ない場合はnothingを返す.

  # 自分より小さい値ならば, 左側
  if node.value > val
    if node.left == nothing # もし左側になければ, 左側にはない
      return nothing
    end
    return findValue(node.left, val)
  end

  # 自分より大きい値ならば, 右側
  if node.value < val
    if node.right == nothing # もし右側になければ, valはない
      return nothing
    end
    return findValue(node.right, val)
  end

  # 見つかれば, 見つかった値を返す
  return node

end

function deleteTree(val, root_node)
  # valを削除する. 成功すればtrue, 失敗すればfalseを返す.

  node = tagTreeNode()
  parent_node = tagTreeNode()
  left_biggest = tagTreeNode()

  node = root_node
  parent_node = nothing
  direction = 0

  # while文で削除すべき対象を見つける(findValueと同じ)
  while node != nothing && node.value != val
    if node.value > val
      parent_node = node
      node = node.left
      direction = -1 # 親の左側
    else
      parent_node = node
      node = node.right
      direction = 1 # 親の右側
    end
  end
  if node == nothing # 見つからなかった
    return false
  end

  if node.left == nothing || node.right == nothing
    # 左か右, どちらかがnothingであった場合 (両方nothingである場合も含む)
    if node.left == nothing
      # 親のポインタを変更する
      if direction == -1
        parent_node.left = node.right
      end
      if direction == 1
        parent_node.right = node.right
      end
      if direction == 0
        tree_root = node.right
      end
    else
      # 親のポインタを変更する
      if direction == -1
        parent_node.left = node.left
      end
      if direction == 1
        parent_node.right = node.left
      end
      if direction == 0
        tree_root = node.left
      end
    end

  else
    # 両者ともnothingでなかった場合

    # nodeの左側の最も大きな値(最も右側の値)を取得する
    left_biggest = node.left

    parent_node = node
    direction = -1
    while left_biggest.right != nothing
      parent_node = left_biggest
      left_biggest = left_biggest.right
      direction = 1
    end

    # left_biggestの値をnodeに代入し, left_biggestは左側の枝を入れる
    node.value = left_biggest.value
    if direction == -1
      parent_node.left = left_biggest.left
    else
      parent_node.right = left_biggest.left
    end
  end

    return true
end

function main()

end

if occursin(PROGRAM_FILE, @__FILE__)
    main()
end
