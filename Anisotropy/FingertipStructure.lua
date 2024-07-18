shape = load("Fingertip.stl")

emit(shape)

--###########################################################

-- setting up printer settings
set_setting_value('printer', 'Prusa_MK3S')
set_setting_value('z_layer_height_mm', 0.2)

-- setting up some slicing settings
set_setting_value('infill_type_0', 'Phasor')
set_setting_value('num_shells_0', 0)
set_setting_value('cover_thickness_mm_0', 0.0)
set_setting_value('print_perimeter_0', false)
set_setting_value('infill_percentage_0',20)

-- printing settings (for TPU, on CR-10 with Titan or Hemera direct extruder)
set_setting_value('filament_priming_mm_0',0.0)
set_setting_value('extruder_temp_degree_c_0',240.0)

set_setting_value('flow_multiplier_0',1)
set_setting_value('speed_multiplier_0',1)
set_setting_value('filament_priming_mm_0',0)

--###########################################################

-- allocating  the field as 3D textures
-- as of today all fields have to be 64x64x64
phi = tex3d_rgb8f(64,64,64)
iso = tex3d_rgb8f(64,64,64)
theta = tex3d_rgb8f(64,64,64)

-- filling the 3D textures
-- values in 3D textures are always in [0,1]
-- the textures can hold up to three components


-- Structure A
for i = 0,63 do
  for j = 0,63 do
    for k = 0,63 do
        if k < 30 then
            iso:set(i,j,k, v(1,1,1))
        else
            iso:set(i,j,k, v(0,0,0))
            phi:set(i,j,k, v(0.25,0.25,0.25))
        end
    end
  end
end

--[[
-- Structure B
for i = 0,63 do
  for j = 0,63 do
    for k = 0,63 do
        if k < 30 then
            iso:set(i,j,k, v(0,0,0))
            phi:set(i,j,k, v(0.25,0.25,0.25))
        elseif k < 50 then
            iso:set(i,j,k, v(1,1,1))
        else
            iso:set(i,j,k, v(0,0,0))
            phi:set(i,j,k, v(0,0,0))
            theta:set(i,j,k, v(0,0,0))
        end
    end
  end
end
--]]

-- binding the 3D textures to the fields
-- the binding requires a field (!), a bounding box where it is applied, and the internal name of the parameter (see tooltip in UI)
set_setting_value('phasor_infill_iso_0', iso, v(-12.5, -12.5, 0), v(12.5, 12.5, 32.5))
set_setting_value('phasor_infill_phi_0', phi, v(-12.5, -12.5, 0), v(12.5, 12.5, 32.5))
set_setting_value('phasor_infill_theta_0', theta, v(-12.5, -12.5, 0), v(12.5, 12.5, 32.5))

--[[
set_setting_value('phasor_infill_iso_0', 0)
set_setting_value('phasor_infill_phi_0', 90)
set_setting_value('phasor_infill_theta_0', 0)
--]]

set_setting_value('infill_percentage_0', 15)
set_setting_value('enable_different_top_bottom_covers_0', true)
set_setting_value('cover_thickness_top_mm_0', 0)
set_setting_value('cover_thickness_bottom_mm_0', 0.4)
