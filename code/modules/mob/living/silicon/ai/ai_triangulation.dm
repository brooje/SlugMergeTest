GLOBAL_VAR_INIT(ai_triangulation_width, 4)

GLOBAL_LIST_EMPTY(ai_polygon_cache)




/atom/proc/start_triangulate()
	for(var/turf/T in world)
		if(T.z == 2)
			T.can_triangulate()

/atom/proc/can_triangulate()

	var/obj/machinery/ai/data_core/n1 
	var/obj/machinery/ai/data_core/n2 

	for(var/obj/machinery/ai/data_core/D in GLOB.data_cores)
		if(!n1)
			n1 = D
			continue
		if(!n2)
			n2 = D
			continue

	if(GLOB.ai_polygon_cache[n1])
		if(GLOB.ai_polygon_cache[n1][n2])
			for(var/turf/T in GLOB.ai_polygon_cache[n1][n2])
				if(T == src)
					src.color = "#00FF00"
					message_admins("cached")
					return
			return

	var/direction = get_dir(n1, n2)
	
	var/atom/n1_p1 = get_step(get_step(n1, turn(direction, 90)), turn(direction, 90))
	var/atom/n1_p2 = get_step(get_step(n1, turn(direction, -90)), turn(direction, -90))
	n1_p1.color = "#FF0000"
	n1_p2.color = "#FF0000"


	var/atom/n2_p1 = get_step(get_step(n2, turn(direction, 90)), turn(direction, 90))
	var/atom/n2_p2 = get_step(get_step(n2, turn(direction, -90)), turn(direction, -90))
	n2_p1.color = "#FF0000"
	n2_p2.color = "#FF0000"

	if(get_dist(n1_p1, n2_p1) > get_dist(n1_p1, n2_p2))
		var/atom/temp = n2_p1
		n2_p1 = n2_p2
		n2_p2 = temp

	
	
	var/list/polygon = list(to_coord_list(n1_p1), to_coord_list(n1_p2), to_coord_list(n2_p1), to_coord_list(n2_p2))

	var/list/points_inside = list()

	
	var/bottom = (n1.x < n2.x) ? n1 : n2
	var/top = (n1.y > n2.y) ? n1 : n2

	for(var/turf/T in block(bottom, top))
		if(T.in_polygon(polygon))
			points_inside += T
			T.color = "#00FF00"

	
	GLOB.ai_polygon_cache[n1] = list()
	GLOB.ai_polygon_cache[n1][n2] = points_inside

	GLOB.ai_polygon_cache[n2] = list()
	GLOB.ai_polygon_cache[n2][n1] = points_inside


/atom/proc/in_polygon(list/polygon)
	if(!polygon)
		return
	if(polygon.len <= 0)
		return
	var/list/point = list(src.x, src.y)
	var/odd = FALSE

	var/j = polygon.len
	for(var/i = 1, i < (polygon.len + 1), i++)
		if(((polygon[i][2] >= point[2]) != (polygon[j][2] >= point[2])) && (point[1] <= ((polygon[j][1] - polygon[i][1]) * (point[2] - polygon[i][2]) / (polygon[j][2] - polygon[i][2]) + polygon[i][1])))
			if(!odd)
				odd = TRUE
			else
				odd = FALSE
		j = i
	return odd
