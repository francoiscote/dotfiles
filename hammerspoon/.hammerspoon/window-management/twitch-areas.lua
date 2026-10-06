-- Fixed screen-coordinate sizes (points on Retina displays).
-- Origins relative to the usable screen's top-left; no margins.
return {
  main = { x = 0, y = 0, w = 1920, h = 1080 },
  secondaryRight = { x = 1920, y = 0, w = 960, h = 1080 },
  secondaryBottom = { x = 0, y = 1080, w = 2880, h = 540 },
}
