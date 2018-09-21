function get_screen_ids(num_screen)
  if num_screen == 1 then
    return {
      center = 1,
    }
  elseif num_screen == 2 then
    return {
      center = 1,
      right = 2,
    }
  else
    return {
      left = 2,
      center = 1,
      right = 3,
    }
  end
end

function get_primary_screen_id(num_screen)
  if num_screen == 1 then
    return 1
  else
    return 2
  end
end

return {
  get_screen_ids = get_screen_ids,
  get_primary_screen_id = get_primary_screen_id,
}
