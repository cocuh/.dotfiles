function get_screen_ids(num_screen)
  if num_screen == 1 then
    return {
      center = 1,
    }
  elseif num_screen == 2 then
    return {
      center = 1,
      right = 2
    }
  else
    return {
      center = 1,
      right = 2
    }
  end
end

function get_primary_screen_id(num_screen)
  return 1
end

return {
  get_screen_ids = get_screen_ids,
  get_primary_screen_id = get_primary_screen_id,
}
