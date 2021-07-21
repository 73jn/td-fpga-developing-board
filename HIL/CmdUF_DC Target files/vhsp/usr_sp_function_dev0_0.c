// generated using template: cop_main.template---------------------------------------------
/******************************************************************************************
**
**  Module Name: cop_main.c
**  NOTE: Automatically generated file. DO NOT MODIFY!
**  Description:
**            Main file
**
******************************************************************************************/
// generated using template: arm/custom_include.template-----------------------------------

#include "math.h"
#include <stdint.h>

// x86 libraries:
#include "../include/sp_functions_dev0.h"

// H files from Advanced C Function components

// Header files from additional sources (Advanced C Function)

// ----------------------------------------------------------------------------------------
// generated using template: VirtualHIL/custom_defines.template----------------------------

typedef unsigned char X_UnInt8;
typedef char X_Int8;
typedef signed short X_Int16;
typedef unsigned short X_UnInt16;
typedef int X_Int32;
typedef unsigned int X_UnInt32;
typedef unsigned int uint;
typedef double real;

// ----------------------------------------------------------------------------------------
// generated using template: custom_consts.template----------------------------------------

// arithmetic constants
#define C_SQRT_2                    1.4142135623730950488016887242097f
#define C_SQRT_3                    1.7320508075688772935274463415059f
#define C_PI                        3.1415926535897932384626433832795f
#define C_E                         2.7182818284590452353602874713527f
#define C_2PI                       6.283185307179586476925286766559f

//@cmp.def.start
//component defines
























//@cmp.def.end


//-----------------------------------------------------------------------------------------
// generated using template: common_variables.template-------------------------------------
// true global variables


//@cmp.var.start
// variables
double _brushless_dc_machine1_machine_wrapper1__out;

double _hall_effect_sensor1_hall_2_pi__out = 6.283185307179586;
double _hall_effect_sensor1_hall_2_pi_over_3__out = 2.0943951023931953;
double _hall_effect_sensor1_hall_4_pi_over_3__out = 4.1887902047863905;
double _hall_effect_sensor1_hall_5_pi_over_3__out = 5.235987755982989;
double _hall_effect_sensor1_hall_pi__out = 3.141592653589793;
double _hall_effect_sensor1_hall_pi_over_3__out = 1.0471975511965976;
double _hall_effect_sensor1_m2e__out;
double _hall_effect_sensor1_rem_theta_2pi___in;


double _hall_effect_sensor1_rem_theta_2pi___out;
double _hall_effect_sensor1_hall_op1__out;
double _hall_effect_sensor1_hall_op2__out;
double _hall_effect_sensor1_hall_op3__out;
double _hall_effect_sensor1_hall_op4__out;
double _hall_effect_sensor1_hall_op5__out;
double _hall_effect_sensor1_hall_op6__out;
double _hall_effect_sensor1_hall_and1__out;
double _hall_effect_sensor1_hall_and2__out;
double _hall_effect_sensor1_hall_and3__out;
float _hall_effect_sensor1_hall_h_a__tmp;
float _hall_effect_sensor1_hall_h_b__tmp;
double _hall_effect_sensor1_hall_bus_join1__out[3];
float _hall_effect_sensor1_hall_h_c__tmp;
//@cmp.var.end

//@cmp.svar.start
// state variables
double _brushless_dc_machine1_machine_wrapper1__model_load;
double _hall_effect_sensor1_rem_theta_2pi___two_pi;
//@cmp.svar.end

//
// Tunable parameters
//
static struct Tunable_params {
} tunable_params;

void *tunable_params_dev0_cpu0_ptr = &tunable_params;





// generated using template: virtual_hil/custom_functions.template---------------------------------
void ReInit_user_sp_cpu0_dev0() {
#if DEBUG_MODE
    printf("\n\rReInitTimer");
#endif
    //@cmp.init.block.start
    _brushless_dc_machine1_machine_wrapper1__model_load = 0.0;
    _hall_effect_sensor1_rem_theta_2pi___two_pi = 6.283185307179586476925286766559;
    HIL_OutAO(0x2000, 0.0f);
    //@cmp.init.block.end
}

void ReInit_sp_scope_user_sp_cpu0_dev0() {
    // initialise SP Scope buffer pointer
}

void load_fmi_libraries_user_sp_cpu0_dev0(void) {
#if defined(_WIN64)
#else
#endif
}
// generated using template:generic_macros.template-----------------------------------------
/*********************** Macros (Inline Functions) Definitions ***************************/

// ----------------------------------------------------------------------------------------

#ifndef MAX
#define MAX(value, limit) (((value) > (limit)) ? (value) : (limit))
#endif
#ifndef MIN
#define MIN(value, limit) (((value) < (limit)) ? (value) : (limit))
#endif

// generated using template: common_timer_counter_handler.template-------------------------

/*****************************************************************************************/
/**
* This function is the handler which performs processing for the timer counter.
* It is called from an interrupt context such that the amount of processing
* performed should be minimized.  It is called when the timer counter expires
* if interrupts are enabled.
*
*
* @param    None
*
* @return   None
*
* @note     None
*
*****************************************************************************************/

void TimerCounterHandler_0_user_sp_cpu0_dev0() {
#if DEBUG_MODE
    printf("\n\rTimerCounterHandler_0");
#endif
    //////////////////////////////////////////////////////////////////////////
    // Set tunable parameters
    //////////////////////////////////////////////////////////////////////////
    // Generated from the component: Hall Effect Sensor1.Hall.2*pi
    // Generated from the component: Hall Effect Sensor1.Hall.2*pi_over_3
    // Generated from the component: Hall Effect Sensor1.Hall.4*pi_over_3
    // Generated from the component: Hall Effect Sensor1.Hall.5*pi_over_3
    // Generated from the component: Hall Effect Sensor1.Hall.pi
    // Generated from the component: Hall Effect Sensor1.Hall.pi_over_3
    //////////////////////////////////////////////////////////////////////////
    // Output block
    //////////////////////////////////////////////////////////////////////////
    //@cmp.out.block.start
    // Generated from the component: Brushless DC Machine1.Machine Wrapper1
    _brushless_dc_machine1_machine_wrapper1__out = HIL_InFloat(0xc80000 + 16395);
    // Generated from the component: Hall Effect Sensor1.Hall.2*pi
    // Generated from the component: Hall Effect Sensor1.Hall.2*pi_over_3
    // Generated from the component: Hall Effect Sensor1.Hall.4*pi_over_3
    // Generated from the component: Hall Effect Sensor1.Hall.5*pi_over_3
    // Generated from the component: Hall Effect Sensor1.Hall.pi
    // Generated from the component: Hall Effect Sensor1.Hall.pi_over_3
    // Generated from the component: Hall Effect Sensor1.m2e
    _hall_effect_sensor1_m2e__out = 3.0 * _brushless_dc_machine1_machine_wrapper1__out;
    // Generated from the component: Hall Effect Sensor1.rem(theta,2pi)
    _hall_effect_sensor1_rem_theta_2pi___in = _hall_effect_sensor1_m2e__out;
    _hall_effect_sensor1_rem_theta_2pi___out = fmod(_hall_effect_sensor1_rem_theta_2pi___in, _hall_effect_sensor1_rem_theta_2pi___two_pi);
    // Generated from the component: Hall Effect Sensor1.Hall.op1
    _hall_effect_sensor1_hall_op1__out = (_hall_effect_sensor1_rem_theta_2pi___out <= _hall_effect_sensor1_hall_2_pi_over_3__out) ? 1 : 0;
    // Generated from the component: Hall Effect Sensor1.Hall.op2
    _hall_effect_sensor1_hall_op2__out = (_hall_effect_sensor1_rem_theta_2pi___out >= _hall_effect_sensor1_hall_5_pi_over_3__out) ? 1 : 0;
    // Generated from the component: Hall Effect Sensor1.Hall.op3
    _hall_effect_sensor1_hall_op3__out = (_hall_effect_sensor1_rem_theta_2pi___out >= _hall_effect_sensor1_hall_pi_over_3__out) ? 1 : 0;
    // Generated from the component: Hall Effect Sensor1.Hall.op4
    _hall_effect_sensor1_hall_op4__out = (_hall_effect_sensor1_rem_theta_2pi___out <= _hall_effect_sensor1_hall_4_pi_over_3__out) ? 1 : 0;
    // Generated from the component: Hall Effect Sensor1.Hall.op5
    _hall_effect_sensor1_hall_op5__out = (_hall_effect_sensor1_rem_theta_2pi___out <= _hall_effect_sensor1_hall_2_pi__out) ? 1 : 0;
    // Generated from the component: Hall Effect Sensor1.Hall.op6
    _hall_effect_sensor1_hall_op6__out = (_hall_effect_sensor1_rem_theta_2pi___out >= _hall_effect_sensor1_hall_pi__out) ? 1 : 0;
    // Generated from the component: Hall Effect Sensor1.theta_e
    HIL_OutAO(0x2000, (float)_hall_effect_sensor1_rem_theta_2pi___out);
    // Generated from the component: Hall Effect Sensor1.Hall.and1
    _hall_effect_sensor1_hall_and1__out = _hall_effect_sensor1_hall_op1__out || _hall_effect_sensor1_hall_op2__out ;
    // Generated from the component: Hall Effect Sensor1.Hall.and2
    _hall_effect_sensor1_hall_and2__out = _hall_effect_sensor1_hall_op3__out && _hall_effect_sensor1_hall_op4__out ;
    // Generated from the component: Hall Effect Sensor1.Hall.and3
    _hall_effect_sensor1_hall_and3__out = _hall_effect_sensor1_hall_op6__out && _hall_effect_sensor1_hall_op5__out ;
    // Generated from the component: Hall Effect Sensor1.Hall.h_A
    HIL_OutInt32(0xf00400, _hall_effect_sensor1_hall_and1__out != 0x0);
    // Generated from the component: Hall Effect Sensor1.Hall.h_B
    HIL_OutInt32(0xf00401, _hall_effect_sensor1_hall_and2__out != 0x0);
    // Generated from the component: Hall Effect Sensor1.Hall.Bus Join1
    _hall_effect_sensor1_hall_bus_join1__out[0] = _hall_effect_sensor1_hall_and1__out;
    _hall_effect_sensor1_hall_bus_join1__out[1] = _hall_effect_sensor1_hall_and2__out;
    _hall_effect_sensor1_hall_bus_join1__out[2] = _hall_effect_sensor1_hall_and3__out;
    // Generated from the component: Hall Effect Sensor1.Hall.h_C
    HIL_OutInt32(0xf00402, _hall_effect_sensor1_hall_and3__out != 0x0);
    // Generated from the component: Termination2
    //@cmp.out.block.end
    //////////////////////////////////////////////////////////////////////////
    // Update block
    //////////////////////////////////////////////////////////////////////////
    //@cmp.update.block.start
    // Generated from the component: Brushless DC Machine1.Machine Wrapper1
    // Generated from the component: Hall Effect Sensor1.rem(theta,2pi)
    //@cmp.update.block.end
}
// ----------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------