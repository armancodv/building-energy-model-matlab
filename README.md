# Building Energy Model (MATLAB) #
It is a small software which is developed by MATLAB for modeling the energy system of a building or a HVAC system.

## Method of Solution ##
In this code, the temperatures are considered variables of the problem, which are solved implicitly by solving a system of linear equations based on energy equations of each element.

## Classes ##

### Boiler ###
#### Equations ####
![Schematic](docs/boiler/schematic.png)
![Equations](docs/boiler/eqs.png)

#### Variables ####

| Symbol | Description | Unit |
| --- | --- | --- |
| *m* | Mass | *kg* |
| *C* | Specific Heat Capacity | *J/(K.kg)* |
| *T* | Temperature | *K* |
| *E.* | Energy Rate | *W* |

| Subscript | Description |
| --- | --- |
| *b* | Boiler |
| *f* | fluid |
| *b,f* | Fluid inside Boiler |
| *b,i* | Boiler Inlet |
| *b,o* | Boiler Outlet |

#### Code ####
##### Construction ######
```Matlab
boiler = Boiler(id_inlet, id_outlet, solver, specific_heat_capacity, mass, specific_heat_capacity_fluid, mass_fluid, power, mass_flow_rate, status);
```

| Input | Description | Type | Unit |
| --- | --- | --- | --- |
| `id_inlet` | Boiler Inlet ID | `integer` | - |
| `id_outlet` | Boiler Outlet ID | `integer` | - |
| `solver` | Class of the Solver | `solver` | - |
| `specific_heat_capacity` | Specific Heat Capacity of the Boiler (without fluid) | `double` | *J/(K.kg)* |
| `mass` | Mass of the Boiler (without fluid) | `double` | *kg* |
| `specific_heat_capacity_fluid` | Specific Heat Capacity of the Fluid | `double` | *J/(K.kg)* |
| `mass_fluid` | Mass of Fluid inside the Boiler | `double` | *kg* |
| `power` | Power of the Boiler | `double` | *W* |
| `mass_flow_rate` | Mass Flow Rate of the Boiler | `double` | *kg/s* |
| `status` | Status of the Boiler (ON/OFF) | `boolean` | - |

##### Create Matrix #####
```Matlab
create(solver)
```

| Input | Description | Type | Unit |
| --- | --- | --- | --- |
| `solver` | Class of the Solver | `solver` | - |

---

### Pipe ###
#### Equations ####
![Schematic](docs/pipe/schematic.png)
![Equations](docs/pipe/eqs.png)

#### Variables ####

| Symbol | Description | Unit |
| --- | --- | --- |
| *h* | Heat Transfer Coefficient | *W/(m<sup>2</sup>K)* |
| *r* | Radius | *m* |
| *k* | Thermal Conductivity | *W.m<sup>-1</sup>.K<sup>-1</sup>* |
| *L* | Length | *m* |
| *U* | equivalent heat transfer coefficient | *W/(m<sup>2</sup>K)* |

| Subscript | Description |
| --- | --- |
| *t* | Pipe |
| *t,f* | Fluid inside Pipe |
| *t,i* | Pipe Inlet |
| *t,o* | Pipe Outlet |
| *t,in* | Pipe Inner Side |
| *t,out* | Pipe Outer Side |

#### Code ####
##### Construction ######
```Matlab
pipe = Pipe(id_inlet, id_outlet, id_zone, solver, specific_heat_capacity, density, specific_heat_capacity_fluid, density_fluid, mass_flow_rate,heat_transfer_coefficient_inner,heat_transfer_coefficient_outer,thermal_conductivity,radius_inner,radius_outer,length);
```

| Input | Description | Type | Unit |
| --- | --- | --- | --- |
| `id_inlet` | Pipe Inlet ID | `integer` | - |
| `id_outlet` | Pipe Outlet ID | `integer` | - |
| `id_zone` | Zone ID | `integer` | - |
| `solver` | Class of the Solver | `solver` | - |
| `specific_heat_capacity` | Specific Heat Capacity of the Pipe (without fluid) | `double` | *J/(K.kg)* |
| `density` | Density of the Pipe (without fluid) | `double` | *kg/m<sup>3</sup>* |
| `specific_heat_capacity_fluid` | Specific Heat Capacity of the Fluid | `double` | *J/(K.kg)* |
| `density_fluid` | Density of Fluid inside the Pipe | `double` | *kg/m<sup>3</sup>* |
| `mass_flow_rate` | Mass Flow Rate of the Pipe | `double` | *kg/s* |
| `heat_transfer_coefficient_inner` | Inner Heat Transfer Coefficient of the Pipe | `double` | *W/(m<sup>2</sup>K)* |
| `heat_transfer_coefficient_outer` | Outer Heat Transfer Coefficient of the Pipe | `double` | *W/(m<sup>2</sup>K)* |
| `thermal_conductivity` | Thermal Conductivity of the Pipe | `double` | *W.m<sup>-1</sup>.K<sup>-1</sup>* |
| `radius_inner` | Inner Radius of the Pipe | `double` | *m* |
| `radius_outer` | Outer Radius of the Pipe | `double` | *m* |
| `length` | Length of the Pipe | `double` | *m* |

##### Create Matrix #####
```Matlab
create(solver)
```

| Input | Description | Type | Unit |
| --- | --- | --- | --- |
| `solver` | Class of the Solver | `solver` | - |

---

### Radiator ###
#### Equations ####
![Equations](docs/radiator/eqs.png)

#### Variables ####

| Subscript | Description |
| --- | --- |
| *r* | Radiator |
| *r,f* | Fluid inside Radiator |
| *r,i* | Radiator Inlet |
| *r,o* | Radiator Outlet |
| *z* | Zone |

#### Code ####
##### Construction ######
```Matlab
radiator = Radiator(id_inlet, id_outlet, id_zone, solver, specific_heat_capacity, mass, specific_heat_capacity_fluid, mass_fluid, mass_flow_rate,heat_transfer_coefficient,surface);
```

| Input | Description | Type | Unit |
| --- | --- | --- | --- |
| `id_inlet` | Radiator Inlet ID | `integer` | - |
| `id_outlet` | Radiator Outlet ID | `integer` | - |
| `id_zone` | Zone ID | `integer` | - |
| `solver` | Class of the Solver | `solver` | - |
| `specific_heat_capacity` | Specific Heat Capacity of the Radiator (without fluid) | `double` | *J/(K.kg)* |
| `mass` | Mass of the Radiator (without fluid) | `double` | *kg* |
| `specific_heat_capacity_fluid` | Specific Heat Capacity of the Fluid | `double` | *J/(K.kg)* |
| `mass_fluid` | Mass of Fluid inside the Radiator | `double` | *kg* |
| `mass_flow_rate` | Mass Flow Rate of the Radiator | `double` | *kg/s* |
| `heat_transfer_coefficient` | Heat Transfer Coefficient of the Radiator | `double` | *W/(m<sup>2</sup>K)* |
| `surface` | Surface of the Radiator | `double` | *m<sup>2</sup>* |

##### Create Matrix #####
```Matlab
create(solver)
```

| Input | Description | Type | Unit |
| --- | --- | --- | --- |
| `solver` | Class of the Solver | `solver` | - |

---

### Mixer ###
#### Equations ####
![Equations](docs/mixer/eqs.png)

#### Variables ####

| Subscript | Description |
| --- | --- |

#### Code ####
##### Construction ######
```Matlab
mixer = Mixer(id_inlets, id_outlets, solver, specific_heat_capacity_inlets, mass_flow_rate_inlets, fracrion_outlets);
```

| Input | Description | Type | Unit |
| --- | --- | --- | --- |
| `id_inlets` | Array of Mixer Inlet ID | `array(integer)` | - |
| `id_outlets` | Array of Mixer Outlet ID | `array(integer)` | - |
| `solver` | Class of the Solver | `solver` | - |
| `specific_heat_capacity_inlets` | Specific Heat Capacity of the Mixer Inlets | `array(double)` | *J/(K.kg)* |
| `mass_flow_rate_inlets` | Mass Flow Rate of the Mixer Inlets | `array(double)` | *kg/s* |
| `fracrion_outlets` | Heat Transfer Coefficient of the Radiator | `array(double)` | *W/(m<sup>2</sup>K)* |

##### Create Matrix #####
```Matlab
create(solver)
```

| Input | Description | Type | Unit |
| --- | --- | --- | --- |
| `solver` | Class of the Solver | `solver` | - |

---

### Zone ###
#### Equations ####
![Equations](docs/zone/eqs.png)

#### Variables ####

| Subscript | Description |
| --- | --- |

#### Code ####
##### Construction ######
```Matlab
zone = Zone(id_zone, id_zones, id_radiator_inlets, id_radiator_outlets, solver, thickness_walls, surface_walls, thickness_windows, surface_windows, surface_radiators, heat_transfer_coefficient_radiators, density_air, volume_air, specific_heat_capacity_air, density_wall, volume_wall, specific_heat_capacity_wall, mass_equipment, specific_heat_capacity_equipment, thermal_conductivity_wall, thermal_conductivity_window);
```

| Input | Description | Type | Unit |
| --- | --- | --- | --- |
| `id_zone` | Zone ID | `integer` | - |
| `id_zones` | Array of Neigthbors' Zones IDs | `array(integer)` | - |
| `id_radiator_inlets` | Array of Radiators Inlets IDs | `array(integer)` | - |
| `id_radiator_outlets` | Array of Radiators Outlets IDs | `array(integer)` | - |
| `solver` | Class of the Solver | `solver` | - |
| `thickness_walls` | Array of Walls Thicknesses | `array(double)` | *m* |
| `surface_walls` | Array of Walls Surfaces | `array(double)` | *m<sup>2</sup>* |
| `thickness_windows` | Array of Windows Thicknesses | `array(double)` | *m* |
| `surface_windows` | Array of Windows Surfaces | `array(double)` | *m<sup>2</sup>* |
| `surface_radiators` | Array of Radiators Surfaces | `array(double)` | *m<sup>2</sup>* |
| `heat_transfer_coefficient_radiators` | Array of Heat Transfer Coefficient of Radiators | `array(double)` | *W/(m<sup>2</sup>K)* |
| `density_air` | Air Density | `double` | *kg/m<sup>3</sup>* |
| `volume_air` | Volume of the Air | `double` | *m<sup>3</sup>* |
| `specific_heat_capacity_air` | Air Specific Heat Capacity | `double` | *J/(K.kg)* |
| `density_wall` | Wall Density | `double` | *kg/m<sup>3</sup>* |
| `volume_wall` | Volume of the Wall | `double` | *m<sup>3</sup>* |
| `specific_heat_capacity_wall` | Wall Heat Transfer Coefficient | `double` | *J/(K.kg)* |
| `mass_equipment` | Mass of Equipment | `double` | *kg* |
| specific_heat_capacity_equipment`` | Equipment Specific Heat Capacity | `double` | *J/(K.kg)* |
| `thermal_conductivity_wall` | Wall Thermal Conductivity | `double` | *W.m<sup>-1</sup>.K<sup>-1</sup>* |
| `thermal_conductivity_window` | Window Thermal Conductivity | `double` | *W.m<sup>-1</sup>.K<sup>-1</sup>* |

##### Create Matrix #####
```Matlab
create(solver)
```

| Input | Description | Type | Unit |
| --- | --- | --- | --- |
| `solver` | Class of the Solver | `solver` | - |

---

### Same ###
#### Code ####
##### Construction ######
```Matlab
same = Same(id_1, id_2, solver);
```

| Input | Description | Type | Unit |
| --- | --- | --- | --- |
| `id_1` | First Element ID | `integer` | - |
| `id_2` | Second Element ID | `integer` | - |
| `solver` | Class of the Solver | `solver` | - |

##### Create Matrix #####
```Matlab
create(solver)
```

| Input | Description | Type | Unit |
| --- | --- | --- | --- |
| `solver` | Class of the Solver | `solver` | - |

---

### HeatExchanger ###
#### Equations ####
![Equations](docs/heatexchanger/eqs.png)

#### Variables ####

| Variable | Description |
| --- | --- |
| *R<sub>c</sub>* | Capacity Ratio |
| *NTU* | Number of Transfer Units |
| *?* | Effectiveness |

| Subscript | Description |
| --- | --- |
| *s* | Supply |
| *d* | Demand |
| *i* | Inlet |
| *o* | Outlet |
| *min* | Minimum |
| *max* | Maximum |

#### Code ####
##### Construction ######
```Matlab
heatExchanger = HeatExchanger(id_supply_inlet, id_supply_outlet, id_demand_inlet, id_demand_outlet, solver, specific_heat_capacity_supply, specific_heat_capacity_demand, mass_flow_rate_supply, mass_flow_rate_demand, heat_transfer_coefficient, surface);
```

| Input | Description | Type | Unit |
| --- | --- | --- | --- |
| `id_supply_inlet` | Supply Inlet Element ID | `integer` | - |
| `id_supply_outlet` | Supply Outlet Element ID | `integer` | - |
| `id_demand_inlet` | Demand Inlet Element ID | `integer` | - |
| `id_demand_outlet` | Demand Outlet Element ID | `integer` | - |
| `solver` | Class of the Solver | `solver` | - |
| `specific_heat_capacity_supply` | Specific Heat Capacity of the Supply | `double` | *J/(K.kg)* |
| `specific_heat_capacity_demand` | Specific Heat Capacity of the Demand | `double` | *J/(K.kg)* |
| `mass_flow_rate_supply` | Mass Flow Rate of the Supply | `double` | *kg/s* |
| `mass_flow_rate_demand` | Mass Flow Rate of the Demand | `double` | *kg/s* |
| `heat_transfer_coefficient` | Heat Transfer Coefficient of the Heat Exchanger | `double` | *W/(m<sup>2</sup>K)* |
| `surface` | Surface of the Heat Exchanger | `double` | *m<sup>2</sup>* |


##### Create Matrix #####
```Matlab
create(solver)
```

| Input | Description | Type | Unit |
| --- | --- | --- | --- |
| `solver` | Class of the Solver | `solver` | - |

---

### Chiller ###
#### Equations ####
![Equations](docs/chiller/eqs.png)

#### Variables ####

| Variable | Description |
| --- | --- |
| *Q.* | Heat Transfer Rate |
| *P* | Electrical Power (input) |
| *COP* | Coefficient of Performance |
| *C* | Water Specific Heat Capacity |

| Subscript | Description |
| --- | --- |
| *e* | Evaporator |
| *c* | Condenser |
| *i* | Inlet |
| *o* | Outlet |

#### Code ####
##### Construction ######
```Matlab
chiller = Chiller(id_condenser_inlet, id_condenser_outlet, id_evaporator_inlet, id_evaporator_outlet, solver, specific_heat_capacity_fluid, power, coefficient_of_performance, mass_flow_rate_condenser, mass_flow_rate_evaporator, status);
```

| Input | Description | Type | Unit |
| --- | --- | --- | --- |
| `id_condenser_inlet` | Condenser Inlet Element ID | `integer` | - |
| `id_condenser_outlet` | Condenser Outlet  Element ID | `integer` | - |
| `id_evaporator_inlet` | Evaporator Inlet Element ID | `integer` | - |
| `id_evaporator_outlet` | Evaporator Outlet Element ID | `integer` | - |
| `solver` | Class of the Solver | `solver` | - |
| `specific_heat_capacity_fluid` | Specific Heat Capacity of Water | `double` | *J/(K.kg)* |
| `power` | Electrical Power | `double` | *W* |
| `coefficient_of_performance` | Coefficient of Performance | `double` | - |
| `mass_flow_rate_condenser` | Mass Flow Rate of the Condenser | `double` | *kg/s* |
| `mass_flow_rate_evaporator` | Mass Flow Rate of the Evaporator | `double` | *kg/s* |


##### Create Matrix #####
```Matlab
create(solver)
```

| Input | Description | Type | Unit |
| --- | --- | --- | --- |
| `solver` | Class of the Solver | `solver` | - |

---

### FanCoil ###
#### Equations ####
![Equations](docs/fancoil/eqs.png)

#### Variables ####

| Variable | Description |
| --- | --- |
| *C.* | Capacitance Flows |
| *Z* | Capacitance Flows Ratio |
| *NTU* | Number of Transfer Unit |
| *?* | Effectiveness |

| Subscript | Description |
| --- | --- |
| *a* | Air |
| *w* | Heating Water |
| *min* | Minimum |
| *max* | Maximum |
| *i* | Inlet |
| *o* | Outlet |

#### Code ####
##### Construction ######
```Matlab
fanCoil = FanCoil(id_heating_inlet, id_heating_outlet, id_cooling_inlet, id_cooling_outlet, id_air_inlet, id_air_outlet, id_zone, solver, specific_heat_capacity_air, specific_heat_capacity_cooling, specific_heat_capacity_heating, mass_flow_rate_air, mass_flow_rate_cooling, mass_flow_rate_heating, status_heating, status_cooling, heat_transfer_coefficient_heating, heat_transfer_coefficient_cooling, surface_heating, surface_cooling);
```

| Input | Description | Type | Unit |
| --- | --- | --- | --- |


##### Create Matrix #####
```Matlab
create(solver)
```

| Input | Description | Type | Unit |
| --- | --- | --- | --- |
| `solver` | Class of the Solver | `solver` | - |

---

### AirHeatExchanger ###
#### Equations ####
![Equations](docs/airheatexchanger/eqs.png)

#### Variables ####

| Variable | Description |
| --- | --- |
| *C.* | Capacitance Flows |
| *HX* | Average Operating Volumetric to Nominal Supply Air Flow Rate |
| *?* | Effectiveness |
| *avg* | Average |
| *Q.* | Heat Transfer Rate |

| Subscript | Description |
| --- | --- |
| *sensible* | Sensible |
| *operating* | Operating |
| *75% flow* | 75% Flow Rate |
| *100% flow* | 100% Flow Rate |
| *s* | Supply |
| *e* | Exhaust |
| *i* | Inlet |
| *o* | Outlet |
| *min* | Minimum |

#### Code ####
##### Construction ######
```Matlab
airHeatExchanger = AirHeatExchanger(id_supply_inlet, id_supply_outlet, id_exhaust_inlet, id_exhaust_outlet, solver, mass_flow_rate_supply_nominal, specific_heat_capacity_supply, specific_heat_capacity_exhaust, mass_flow_rate_supply, mass_flow_rate_exhaust, sensible_effectiveness_75, sensible_effectiveness_100, latent_effectiveness_75, latent_effectiveness_100);
```

| Input | Description | Type | Unit |
| --- | --- | --- | --- |


##### Create Matrix #####
```Matlab
create(solver)
```

| Input | Description | Type | Unit |
| --- | --- | --- | --- |
| `solver` | Class of the Solver | `solver` | - |

---

### Solver ###
#### Equations ####
![Equations](docs/solver/eqs.png)

#### Code ####
##### Construction ######
```Matlab
Solver(time_step, matrix_size, initial_temperature)
```

| Input | Description | Type | Unit |
| --- | --- | --- | --- |
| `time_step` | Time Step | `double` | s |
| `matrix_size` | Number of Variables of System of Linear Equations | `integer` | - |
| `initial_temperature` | Array of Initial Temperatures | `array(double)` | K |

##### Iterate #####
```Matlab
[solver, boilers, pipes, radiators, mixers, zones, sames, heatExchangers, chillers, fanCoils] = solver.iterate(boilers, pipes, radiators, mixers, zones, sames, heatExchangers, chillers, fanCoils);
```

## License ##
GNU GENERAL PUBLIC LICENSE
Version 2, June 1991
