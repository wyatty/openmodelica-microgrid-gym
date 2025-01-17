#####################################
# Example using a FMU by OpenModelica as gym environment containing two inverters, each connected via an LC-filter to
# supply in parallel a RL load.
# This example uses the available standard controllers as defined in the 'auxiliaries' folder.
# One inverter is set up as voltage forming inverter with a direct droop controller.
# The other controller is used as current sourcing inverter with an inverse droop controller which reacts on the
# frequency and voltage change due to its droop control parameters by a power/reactive power change.

import logging
from functools import partial

import gym
import numpy as np
from matplotlib import pyplot as plt

from openmodelica_microgrid_gym import Runner
from openmodelica_microgrid_gym.agents import StaticControlAgent
from openmodelica_microgrid_gym.aux_ctl import PI_params, DroopParams, MultiPhaseDQ0PIPIController, \
    MultiPhaseDQCurrentController, InverseDroopParams, PLLParams
from openmodelica_microgrid_gym.env import PlotTmpl
from openmodelica_microgrid_gym.net import Network

# Simulation definitions
max_episode_steps = 3000  # number of simulation steps per episode
num_episodes = 1  # number of simulation episodes
# (here, only 1 episode makes sense since simulation conditions don't change in this example)
DroopGain = 40000.0  # virtual droop gain for active power / W/Hz
QDroopGain = 1000.0  # virtual droop gain for reactive power / VAR/V
net = Network.load('../net/net.yaml')
delta_t = net.ts  # simulation time step size / s
freq_nom = net.freq_nom  # nominal grid frequency / Hz
v_nom = net.v_nom  # nominal grid voltage / V
v_DC = net['inverter1'].v_DC  # DC-link voltage / V; will be set as model parameter in the FMU
i_lim = net['inverter1'].i_lim  # inverter current limit / A
i_nom = net['inverter1'].i_nom  # nominal inverter current / A

logging.basicConfig()


def load_step(t, gain):
    """
    Doubles the load parameters
    :param t:
    :param gain: device parameter
    :return: Dictionary with load parameters
    """
    # Defines a load step after 0.2 s
    return 1 * gain if t < .2 else 2 * gain


if __name__ == '__main__':
    ctrl = []  # Empty dict which shall include all controllers

    #####################################
    # Define the voltage forming inverter as master
    # Voltage control PI gain parameters for the voltage sourcing inverter
    voltage_dqp_iparams = PI_params(kP=0.025, kI=60, limits=(-i_lim, i_lim))
    # Current control PI gain parameters for the voltage sourcing inverter
    current_dqp_iparams = PI_params(kP=0.012, kI=90, limits=(-1, 1))
    # Droop characteristic for the active power Watt/Hz, delta_t
    droop_param = DroopParams(DroopGain, 0.005, freq_nom)
    # Droop characteristic for the reactive power VAR/Volt Var.s/Volt
    qdroop_param = DroopParams(QDroopGain, 0.002, v_nom)
    # Add to dict
    ctrl.append(MultiPhaseDQ0PIPIController(voltage_dqp_iparams, current_dqp_iparams, droop_param,
                                            qdroop_param, ts_sim=delta_t, name='master'))

    #####################################
    # Define the current sourcing inverter as slave
    # Current control PI gain parameters for the current sourcing inverter
    current_dqp_iparams = PI_params(kP=0.005, kI=200, limits=(-1, 1))
    # PI gain parameters for the PLL in the current forming inverter
    pll_params = PLLParams(kP=10, kI=200, limits=None, f_nom=freq_nom)
    # Droop characteristic for the active power Watts/Hz, W.s/Hz
    droop_param = InverseDroopParams(DroopGain, delta_t, freq_nom, tau_filt=0.04)
    # Droop characteristic for the reactive power VAR/Volt Var.s/Volt
    qdroop_param = InverseDroopParams(50, delta_t, v_nom, tau_filt=0.01)
    # Add to dict
    ctrl.append(MultiPhaseDQCurrentController(current_dqp_iparams, pll_params, i_lim,
                                              droop_param, qdroop_param, ts_sim=delta_t, name='slave'))

    # Define the agent as StaticControlAgent which performs the basic controller steps for every environment set
    agent = StaticControlAgent(ctrl, {'master': [[f'lc1.inductor{k}.i' for k in '123'],
                                                 [f'lc1.capacitor{k}.v' for k in '123']],
                                      'slave': [[f'lcl1.inductor{k}.i' for k in '123'],
                                                [f'lcl1.capacitor{k}.v' for k in '123'],
                                                [f'inverter2.i_ref.{k}' for k in '012']]})  # np.zeros(3)]})


    def update_legend(fig):
        ax = fig.gca()
        ax.set_xlabel(r'$t\,/\,\mathrm{s}$')
        ax.set_ylabel('$i_{\mathrm{abc}}\,/\,\mathrm{A}$')
        ax.grid(which='both')
        plt.legend(handles=ax.lines[::3], labels=('Measurement abc', 'Setpoint dq0'))
        fig.show()


    # Define the environment
    env = gym.make('openmodelica_microgrid_gym:ModelicaEnv_test-v1',
                   viz_mode='episode',
                   viz_cols=[
                       PlotTmpl([[f'lcl1.inductor{i}.i' for i in '123'], [f'slave.SPI{i}' for i in 'dq0']],
                                callback=update_legend,
                                color=[['b', 'r', 'g'], ['b', 'r', 'g']],
                                style=[[None], ['--']],
                                title='Example of using an timevariant external current reference'
                                ),
                   ],
                   log_level=logging.INFO,
                   max_episode_steps=max_episode_steps,
                   model_params={'rl1.resistor1.R': partial(load_step, gain=20),
                                 'rl1.resistor2.R': partial(load_step, gain=20),
                                 'rl1.resistor3.R': partial(load_step, gain=20),
                                 'rl1.inductor1.L': 0.001,
                                 'rl1.inductor2.L': 0.001,
                                 'rl1.inductor3.L': 0.001
                                 },
                   model_path='../omg_grid/grid.network.fmu',
                   net=net
                   )

    # User runner to execute num_episodes-times episodes of the env controlled by the agent
    runner = Runner(agent, env)


    def timeshift(component, t):
        if t > .1:
            return dict(i_ref=np.array([30, 0, 0]))
        return dict(i_ref=np.array([5, 0, 0]))


    net['inverter2'].post_calculate_hook = timeshift
    runner.run(num_episodes, visualise=True)
