module Utils
  module_function()

  def get_opposite_point(origin, point)
    v = point - origin
    return origin + v.reverse
  end

  def get_flipped_point(origin, point, axis)
    v = point - origin
    axis_idx_map = {'x'=>0, 'y'=>1, 'z'=>2}
    if v.respond_to?(axis)
      axis_idx = axis_idx_map[axis]
      v[axis_idx] = -v[axis_idx]
      return origin + v
    else
      return point
    end
  end

  def convert_2d_to_point3d(pt)
    return Geom::Point3d.new(pt[0].mm, pt[1].mm, 0)
  end

  def convert_array_to_normal_v(v)
    return Geom::Vector3d.new(v[0], v[1], v[2]).normalize
  end

  def get_offset_points(points, dist, open=false) # dist부호: points 진행 방향의 오른쪽 +, 왼쪽 - (반시계방향으로 진행하면서 닫힌 곡선의 경우 + => 바깥쪽)
    if open
      offset_lines = []
      for i in 0..points.length-1
        start_point = points[i-1]
        end_point = points[i]

        z = Geom::Vector3d.new(0,0,1)
        if dist>0
          deg = -90.degrees
        else
          deg = 90.degrees
        end
        rot = Geom::Transformation.rotation(start_point, z, deg)
        # v = get_vector3d(start_point, end_point)
        v = end_point - start_point
        v_h = v.transform(rot)

        offset_stp = start_point.offset(v_h, dist)

        line = [offset_stp, v] # sketchup line definition,, array[point, vector]
        offset_lines.push(line)
      end

      offset_points = []
      for i in 0..offset_lines.length-1
        line1 = offset_lines[i-1]
        line2 = offset_lines[i]
        ints_point = Geom.intersect_line_line(line1, line2)
        offset_points.push(ints_point)
      end
      last = offset_points[0]
      offset_points = offset_points.slice(1, offset_points.length).push(last)
    else
      offset_lines = []
      offset_points = []
      for i in 1..points.length-1 # 열린 라인일 경우 두번째 점부터 마지막 점까지만 iter
        start_point = points[i-1]
        end_point = points[i]

        z = Geom::Vector3d.new(0,0,1)
        if dist>0
          deg = -90.degrees
        else
          deg = 90.degrees
        end
        rot = Geom::Transformation.rotation(start_point, z, deg)
        # v = get_vector3d(start_point, end_point)
        v = end_point - start_point
        v_h = v.transform(rot)

        offset_stp = start_point.offset(v_h, dist)

        line = [offset_stp, v] # sketchup line definition,, array[point, vector]
        offset_lines.push(line)
        if i==1
          offset_points.push(offset_stp)
        elsif i==points.length-1
          offset_enp = end_point.offset(v_h, dist)
        end
      end

      # 첫번째 오프셋 포인트 이미 들어간 상태에서 라인들의 교차점 추가
      for i in 1..offset_lines.length-1
        line1 = offset_lines[i-1]
        line2 = offset_lines[i]
        ints_point = Geom.intersect_line_line(line1, line2)
        offset_points.push(ints_point)
      end

      offset_points.push(offset_enp)
    end

    return offset_points, offset_lines
  end

end
