# Energy Model of Building (MATLAB) #
It is a small software which is developed by MATLAB for modeling the energy system of a building or a HVAC system.

## Method of Solution ##
In this code, the temperatures are considered variables of the problem, which are solved implicitly by solving a system of linear equations based on energy equations of each element.

## Classes ##

### Boiler ###
#### Equations ####
##### Energy Equation of a Boiler #####
![Alt text](docs/boiler/eq1.png "Energy Equation of a Boiler")

##### Descritized Equation of a Boiler #####
![Alt text](docs/boiler/eq2.png "Descritized Equation of a Boiler")

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
```matlab
Boiler(id_inlet, id_outlet, solver, specific_heat_capacity, mass, specific_heat_capacity_fluid, mass_fluid, power, mass_flow_rate, status)
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
```matlab
create(temperatures)
```

### Pipe ###
#### Equations ####
##### Energy Equation of a Pipe #####
![Alt text](docs/pipe/eq1.png "Energy Equation of a Pipe")

##### Descritized Equation of a Pipe #####
![Alt text](docs/pipe/eq2.png "Descritized Equation of a Pipe")

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
| *t,in* | Pipe Inside |
| *t,out* | Pipe Outside |

#### Code ####
##### Construction ######
```matlab
Pipe(id_inlet, id_outlet, id_zone, solver, specific_heat_capacity, density, specific_heat_capacity_fluid, density_fluid, mass_flow_rate,heat_transfer_coefficient_inner,heat_transfer_coefficient_outer,thermal_conductivity,radius_inner,radius_outer,length)
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
```matlab
create(temperatures)
```


### Radiator ###
#### Equations ####
##### Energy Equation of a Radiator #####
![Alt text](docs/radiator/eq1.png "Energy Equation of a Radiator")

##### Descritized Equation of a Radiator #####
![Alt text](docs/radiator/eq2.png "Descritized Equation of a Radiator")

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
`Radiator(id_inlet, id_outlet, id_zone, solver, specific_heat_capacity, mass, specific_heat_capacity_fluid, mass_fluid, mass_flow_rate,heat_transfer_coefficient,surface)`

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
```matlab
create(temperatures)
```


## License ##
BSD 2-Clause License

Copyright (c) 2019, Armanco
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
