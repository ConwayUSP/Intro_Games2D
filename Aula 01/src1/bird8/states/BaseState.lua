--[[
    esta e a classe base para todos os nossos estados.
    ela serve como uma interface: define os metodos que todos os estados
    devem ter (init, enter, exit, update, render).
    
    ao deixar estes metodos vazios aqui, evitamos erros no futuro caso
    criemos um estado que nao precise de algum deles (ex: um estado que nao tem update).
]]

BaseState = Class{}

function BaseState:init() end
function BaseState:enter() end
function BaseState:exit() end
function BaseState:update(dt) end
function BaseState:render() end