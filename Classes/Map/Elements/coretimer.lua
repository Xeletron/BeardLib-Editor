EditorTimer = EditorTimer or class(MissionScriptEditor)
EditorTimer.SAVE_UNIT_POSITION = false
EditorTimer.SAVE_UNIT_ROTATION = false
EditorTimer.INSTANCE_VAR_NAMES = {{type = "number", value = "timer"}}
EditorTimer.RANDOMS = {"timer"}
EditorTimer.CLASS = "ElementTimer"
EditorTimer.MODULE = "CoreElementTimer"
function EditorTimer:create_element()
	EditorTimer.super.create_element(self)
	self._digital_gui_units = {}
	self._element.values.timer = {0, 0}
	self._element.values.digital_gui_unit_ids = {}
end

function EditorTimer:check_unit(unit)
	return unit:digital_gui() and unit:digital_gui():is_timer()
end

function EditorTimer:_build_panel()
	self:_create_panel()
	self:BuildUnitsManage("digital_gui_unit_ids", nil, nil, {text = "Timer Units", check_unit = ClassClbk(self, "check_unit")})
	self:NumberCtrl("timer", {floats = 1, min = 0, help = "Specifies how long time (in seconds) to wait before execute"})
	self:Text("Creates a timer element. When the timer runs out, execute will be run. The timer element can be operated on using the timer operator element")
end

EditorHeistTimer = EditorHeistTimer or class(EditorTimer)
EditorHeistTimer.CLASS = "ElementHeistTimer"

EditorTimerOperator = EditorTimerOperator or class(MissionScriptEditor)
EditorTimerOperator.RANDOMS = {"time"}
EditorTimerOperator.LINK_ELEMENTS = {"elements"}
EditorTimerOperator.CLASS = "ElementTimerOperator"
EditorTimerOperator.MODULE = "CoreElementTimer"
EditorTimerOperator.ELEMENTS = {"ElementTimer"}
function EditorTimerOperator:create_element()
	EditorTimerOperator.super.create_element(self)
	self._element.values.operation = "none"
	self._element.values.time = {0, 0}
	self._element.values.elements = {}
end

function EditorTimerOperator:_build_panel()
	self:_create_panel()
	self:BuildElementsManage("elements", nil, self.ELEMENTS)
	self:ComboCtrl("operation", {"none","pause","start","add_time","subtract_time","reset","set_time"}, {help = "Select an operation for the selected elements"})
	self:NumberCtrl("time", {floats = 1, min = 0, help = "Amount of time to add, subtract or set to the timers."})
	self:Text("This element can modify timer element.")
end

EditorTimerTrigger = EditorTimerTrigger or class(MissionScriptEditor)
EditorTimerTrigger.LINK_ELEMENTS = {"elements"}
EditorTimerTrigger.CLASS = "ElementTimerTrigger"
EditorTimerTrigger.MODULE = "CoreElementTimer"
EditorTimerTrigger.ELEMENTS = {"ElementTimer"}

function EditorTimerTrigger:create_element()
	EditorTimerTrigger.super.create_element(self)
	self._element.values.time = 0
	self._element.values.elements = {}
end
function EditorTimerTrigger:_build_panel()
	self:_create_panel()
	self:BuildElementsManage("elements", nil, self.ELEMENTS)
	self:NumberCtrl("time", {floats = 1, min = 0, help = "Specify how much time should be left on the timer to trigger"})
	self:Text("This element is a trigger to timer element.")
end

EditorHeistTimer = EditorHeistTimer or class(EditorTimerOperator)
EditorHeistTimer.CLASS = "ElementHeistTimer"

EditorHeistTimerOperator = EditorHeistTimerOperator or class(EditorTimerOperator)
EditorHeistTimerOperator.CLASS = "ElementHeistTimerOperator"
EditorHeistTimerOperator.ELEMENTS = {"ElementHeistTimer"}

EditorHeistTimerTrigger = EditorHeistTimerTrigger or class(EditorTimerTrigger)
EditorHeistTimerTrigger.CLASS = "ElementHeistTimerTrigger"
EditorHeistTimerTrigger.ELEMENTS = {"ElementHeistTimer"}