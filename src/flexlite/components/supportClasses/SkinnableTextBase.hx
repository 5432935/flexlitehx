package flexlite.components.supportclasses;



import flash.display.DisplayObject;
import flash.display.InteractiveObject;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.TextEvent;
import flash.Lib;


import flexlite.components.EditableText;
import flexlite.components.SkinnableComponent;
import flexlite.core.FlexLiteGlobals;
import flexlite.core.IDisplayText;
import flexlite.core.IEditableText;
import flexlite.core.IStateClient;



/**
* 当控件中的文本通过用户输入发生更改后分派。使用代码更改文本时不会引发此事件。 
*/
@:meta(Event(name="change",type="flash.events.Event"))


/**
* 当控件中的文本通过用户输入发生更改之前分派。但是当用户按 Delete 键或 Backspace 键时，不会分派任何事件。
* 可以调用preventDefault()方法阻止更改。  
*/
@:meta(Event(name="textInput",type="flash.events.TextEvent"))


@:meta(DXML(show="false"))


@:meta(SkinState(name="normal"))

@:meta(SkinState(name="disabled"))

@:meta(SkinState(name="normalWithPrompt"))

@:meta(SkinState(name="disabledWithPrompt"))


/**
* 可设置外观的文本输入控件基类
* @author weilichuang
*/
class SkinnableTextBase extends SkinnableComponent
{
    public var prompt(get, set) : String;
    public var textColor(get, set) : Int;
    public var displayAsPassword(get, set) : Bool;
    public var editable(get, set) : Bool;
    public var maxChars(get, set) : Int;
    public var restrict(get, set) : String;
    public var selectable(get, set) : Bool;
    public var selectionBeginIndex(get, never) : Int;
    public var selectionEndIndex(get, never) : Int;
    public var caretIndex(get, never) : Int;
    public var text(get, set) : String;

    public function new()
    {
        super();
        focusEnabled = true;
        addEventListener(FocusEvent.FOCUS_IN, focusInHandler);
        addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
    }
    /**
	* 焦点移入
	*/
    private function focusInHandler(event : FocusEvent) : Void
    {
        if (event.target == this) 
        {
            setFocus();
            return;
        }
        invalidateSkinState();
    }
    /**
	* 焦点移出
	*/
    private function focusOutHandler(event : FocusEvent) : Void
    {
        if (event.target == this) 
            return;
        invalidateSkinState();
    }
    
    /**
	* [SkinPart]实体文本输入组件
	*/
	@SkinPart
    public var textDisplay : IEditableText;
    /**
	* textDisplay改变时传递的参数
	*/
    private var textDisplayProperties : Dynamic = { };
    /**
	* [SkinPart]当text属性为空字符串时要显示的文本。
	*/
	@SkinPart
    public var promptDisplay : IDisplayText;
    
    private var _prompt : String;
    /**
	* 当text属性为空字符串时要显示的文本内容。 <p/>
	* 先创建文本控件时将显示提示文本。控件获得焦点时或控件的 text 属性为非空字符串时，提示文本将消失。
	* 控件失去焦点时提示文本将重新显示，但仅当未输入文本时（如果文本字段的值为空字符串）。<p/>
	* 对于文本控件，如果用户输入文本，但随后又将其删除，则控件失去焦点后，提示文本将重新显示。
	* 您还可以通过编程方式将文本控件的 text 属性设置为空字符串使提示文本重新显示。
	*/
    private function get_prompt() : String
    {
        return _prompt;
    }
    private function set_prompt(value : String) : String
    {
        if (_prompt == value) 
            return value;
        _prompt = value;
        if (promptDisplay != null) 
        {
            promptDisplay.text = value;
        }
        invalidateProperties();
        invalidateSkinState();
        return value;
    }
    
    /**
	* @inheritDoc
	*/
    override private function get_maxWidth() : Float
    {
        if (textDisplay != null) 
            return textDisplay.maxWidth;
        var v : Dynamic = textDisplayProperties.maxWidth;
        return ((v == null)) ? super.maxWidth : v;
    }
    
    /**
	* @inheritDoc
	*/
    override private function set_maxWidth(value : Float) : Float
    {
        if (textDisplay != null) 
        {
            textDisplay.maxWidth = value;
            textDisplayProperties.maxWidth = true;
        }
        else 
        {
            textDisplayProperties.maxWidth = value;
        }
        invalidateProperties();
        return value;
    }
    
    /**
	* 文本颜色。
	*/
    private function get_textColor() : Int
    {
        if (textDisplay != null) 
            return textDisplay.textColor;
        var v : Dynamic = textDisplayProperties.textColor;
        return ((v == null)) ? 0 : v;
    }
    private function set_textColor(value : Int) : Int
    {
        if (textDisplay != null) 
        {
            textDisplay.textColor = value;
            textDisplayProperties.textColor = true;
        }
        else 
        {
            textDisplayProperties.textColor = value;
        }  //触发一次UPDATE_COMPLETE事件.  
        
        invalidateProperties();
        return value;
    }
    
    /**
	* 指定文本字段是否是密码文本字段。如果此属性的值为 true，则文本字段被视为密码文本字段，并使用星号而不是实际字符来隐藏输入的字符。
	* 如果为 false，则不会将文本字段视为密码文本字段。启用密码模式时，“剪切”和“复制”命令及其对应的键盘快捷键将不起作用。
	* 此安全机制可防止不良用户使用快捷键在无人看管的计算机上破译密码。
	*/
    private function get_displayAsPassword() : Bool
    {
        if (textDisplay != null) 
            return textDisplay.displayAsPassword;
        var v : Dynamic = textDisplayProperties.displayAsPassword;
        return ((v == null)) ? false : v;
    }
    
    private function set_displayAsPassword(value : Bool) : Bool
    {
        if (textDisplay != null) 
        {
            textDisplay.displayAsPassword = value;
            textDisplayProperties.displayAsPassword = true;
        }
        else 
        {
            textDisplayProperties.displayAsPassword = value;
        }
        invalidateProperties();
        return value;
    }
    
    /**
	* 文本是否可编辑的标志。
	*/
    private function get_editable() : Bool
    {
        if (textDisplay != null) 
            return textDisplay.editable;
        var v : Dynamic = textDisplayProperties.editable;
        return ((v == null)) ? true : v;
    }
    
    private function set_editable(value : Bool) : Bool
    {
        if (textDisplay != null) 
        {
            textDisplay.editable = value;
            textDisplayProperties.editable = true;
        }
        else 
        {
            textDisplayProperties.editable = value;
        }
        invalidateProperties();
        return value;
    }
    
    /**
	* 文本字段中最多可包含的字符数（即用户输入的字符数）。脚本可以插入比 maxChars 允许的字符数更多的文本；
	* maxChars 属性仅表示用户可以输入多少文本。如果此属性的值为 0，则用户可以输入无限数量的文本。
	*/
    private function get_maxChars() : Int
    {
        if (textDisplay != null) 
            return textDisplay.maxChars;
        var v : Dynamic = textDisplayProperties.maxChars;
        return ((v == null)) ? 0 : v;
    }
    
    private function set_maxChars(value : Int) : Int
    {
        if (textDisplay != null) 
        {
            textDisplay.maxChars = value;
            textDisplayProperties.maxChars = true;
        }
        else 
        {
            textDisplayProperties.maxChars = value;
        }
        invalidateProperties();
        return value;
    }
    
    /**
	* 表示用户可输入到文本字段中的字符集。如果 restrict 属性的值为 null，则可以输入任何字符。
	* 如果 restrict 属性的值为空字符串，则不能输入任何字符。如果 restrict 属性的值为一串字符，
	* 则只能在文本字段中输入该字符串中的字符。从左向右扫描该字符串。可以使用连字符 (-) 指定一个范围。
	* 只限制用户交互；脚本可将任何文本放入文本字段中。此属性不与属性检查器中的“嵌入字体”选项同步。<p/>
	* 如果字符串以尖号 (ˆ) 开头，则先接受所有字符，然后从接受字符集中排除字符串中 ˆ 之后的字符。
	* 如果字符串不以尖号 (ˆ) 开头，则最初不接受任何字符，然后将字符串中的字符包括在接受字符集中。
	*/
    private function get_restrict() : String
    {
        if (textDisplay != null) 
            return textDisplay.restrict;
        var v : Dynamic = textDisplayProperties.restrict;
        return ((v == null)) ? null : v;
    }
    
    private function set_restrict(value : String) : String
    {
        if (textDisplay != null) 
        {
            textDisplay.restrict = value;
            textDisplayProperties.restrict = true;
        }
        else 
        {
            textDisplayProperties.restrict = value;
        }
        invalidateProperties();
        return value;
    }
    
    /**
	* 一个布尔值，表示文本字段是否可选。值 true 表示文本可选。selectable 属性控制文本字段是否可选，
	* 而不控制文本字段是否可编辑。动态文本字段即使不可编辑，它也可能是可选的。如果动态文本字段是不可选的，
	* 则用户不能选择其中的文本。 <p/>
	* 如果 selectable 设置为 false，则文本字段中的文本不响应来自鼠标或键盘的选择命令，
	* 并且不能使用“复制”命令复制文本。如果 selectable 设置为 true，则可以使用鼠标或键盘选择文本字段中的文本，
	* 并且可以使用“复制”命令复制文本。即使文本字段是动态文本字段而不是输入文本字段，您也可以用这种方式选择文本。 
	*/
    private function get_selectable() : Bool
    {
        if (textDisplay != null) 
            return textDisplay.selectable;
        var v : Dynamic = textDisplayProperties.selectable;
        return ((v == null)) ? true : v;
    }
    
    private function set_selectable(value : Bool) : Bool
    {
        if (textDisplay != null) 
        {
            textDisplay.selectable = value;
            textDisplayProperties.selectable = true;
        }
        else 
        {
            textDisplayProperties.selectable = value;
        }
        invalidateProperties();
        return value;
    }
    
    /**
	* 当前所选内容中第一个字符从零开始的字符索引值。例如，第一个字符的索引值是 0，
	* 第二个字符的索引值是 1，依此类推。如果未选定任何文本，此属性为 caretIndex 的值
	*/
    private function get_selectionBeginIndex() : Int
    {
        if (textDisplay != null) 
            return textDisplay.selectionBeginIndex;
        if (textDisplayProperties.selectionBeginIndex == null) 
            return -1;
        return textDisplayProperties.selectionBeginIndex;
    }
    
    /**
	* 当前所选内容中最后一个字符从零开始的字符索引值。例如，第一个字符的索引值是 0，第二个字符的索引值是 1，
	* 依此类推。如果未选定任何文本，此属性为 caretIndex 的值。
	*/
    private function get_selectionEndIndex() : Int
    {
        if (textDisplay != null) 
            return textDisplay.selectionEndIndex;
        if (textDisplayProperties.selectionEndIndex == null) 
            return -1;
        return textDisplayProperties.selectionEndIndex;
    }
    
    /**
	* 插入点（尖号）位置的索引。如果没有显示任何插入点，则在将焦点恢复到字段时，
	* 值将为插入点所在的位置（通常为插入点上次所在的位置，如果字段不曾具有焦点，则为 0）。 
	*/
    private function get_caretIndex() : Int
    {
        return (textDisplay != null) ? textDisplay.caretIndex : 0;
    }
    
    /**
	* 将第一个字符和最后一个字符的索引值（使用 beginIndex 和 endIndex 参数指定）指定的文本设置为所选内容。
	* 如果两个参数值相同，则此方法会设置插入点，就如同设置 caretIndex 属性一样。
	*/
    public function setSelection(beginIndex : Int, endIndex : Int) : Void
    {
        if (textDisplay != null) 
        {
            textDisplay.setSelection(beginIndex, endIndex);
        }
        else 
        {
            textDisplayProperties.selectionBeginIndex = beginIndex;
            textDisplayProperties.selectionEndIndex = endIndex;
        }
    }
    
    /**
	* 选中所有文本。
	*/
    public function selectAll() : Void
    {
        if (textDisplay != null) 
        {
            textDisplay.selectAll();
        }
        else if (textDisplayProperties.text != null) 
        {
            setSelection(0, Std.int(textDisplayProperties.text.length - 1));
        }
    }
    
    /**
	* 此文本组件所显示的文本。
	*/
    private function get_text() : String
    {
        if (textDisplay != null) 
            return textDisplay.text;
        var v : Dynamic = textDisplayProperties.text;
        return ((v == null)) ? "" : v;
    }
    
    private function set_text(value : String) : String
    {
        if (textDisplay != null) 
        {
            textDisplay.text = value;
            textDisplayProperties.text = true;
        }
        else 
        {
            textDisplayProperties.text = value;
            textDisplayProperties.selectionBeginIndex = 0;
            textDisplayProperties.selectionEndIndex = 0;
        }
        invalidateProperties();
        invalidateSkinState();
        return value;
    }
    
    private function getWidthInChars() : Float
    {
        var richEditableText : EditableText = cast(textDisplay, EditableText);
        
        if (richEditableText != null) 
            return richEditableText.widthInChars;
        
        var v : Dynamic = (textDisplay != null) ? null : textDisplayProperties.widthInChars;
        return ((v == null)) ? Math.NaN : v;
    }
    
    private function setWidthInChars(value : Float) : Void
    {
        if (textDisplay != null) 
        {
            var richEditableText : EditableText = cast(textDisplay, EditableText);
            
            if (richEditableText != null) 
                richEditableText.widthInChars = value;
            textDisplayProperties.widthInChars = true;
        }
        else 
        {
            textDisplayProperties.widthInChars = value;
        }
        
        invalidateProperties();
    }
    
    private function getHeightInLines() : Float
    {
        var richEditableText : EditableText = cast(textDisplay, EditableText);
        
        if (richEditableText != null) 
            return richEditableText.heightInLines;
        
        var v : Dynamic = (textDisplay != null) ? null : textDisplayProperties.heightInLines;
        return ((v == null)) ? Math.NaN : v;
    }
    
    private function setHeightInLines(value : Float) : Void
    {
        if (textDisplay != null) 
        {
            var richEditableText : EditableText = cast(textDisplay, EditableText);
            
            if (richEditableText != null) 
                richEditableText.heightInLines = value;
            textDisplayProperties.heightInLines = true;
        }
        else 
        {
            textDisplayProperties.heightInLines = value;
        }
        
        invalidateProperties();
    }
    
    /**
	* @inheritDoc
	*/
    override private function getCurrentSkinState() : String
    {
        var focus : InteractiveObject = FlexLiteGlobals.stage.focus;
        var skin : Dynamic = skinObject;
        if (_prompt != null && Std.is(skin, IStateClient) &&
            (focus == null || !contains(focus)) && text == "") 
        {
            if (enabled && Lib.as(skin, IStateClient).hasState("normalWithPrompt")) 
                return "normalWithPrompt";
            if (!enabled && Lib.as(skin, IStateClient).hasState("disabledWithPrompt")) 
                return "disabledWithPrompt";
        }
        return super.getCurrentSkinState();
    }
    
    /**
	* @inheritDoc
	*/
    override private function partAdded(partName : String, instance : Dynamic) : Void
    {
        super.partAdded(partName, instance);
        
        if (instance == textDisplay) 
        {
            textDisplayAdded();
            
            textDisplay.addEventListener(TextEvent.TEXT_INPUT,
                    textDisplay_changingHandler);
            
            textDisplay.addEventListener(Event.CHANGE,
                    textDisplay_changeHandler);
        }
        else if (instance == promptDisplay) 
        {
            promptDisplay.text = _prompt;
        }
    }
    
    /**
	* @inheritDoc
	*/
    override private function partRemoved(partName : String,
            instance : Dynamic) : Void
    {
        super.partRemoved(partName, instance);
        
        if (instance == textDisplay) 
        {
            textDisplayRemoved();
            
            textDisplay.removeEventListener(TextEvent.TEXT_INPUT,
                    textDisplay_changingHandler);
            
            textDisplay.removeEventListener(Event.CHANGE,
                    textDisplay_changeHandler);
        }
    }
    
    /**
	* @inheritDoc
	*/
    override public function setFocus() : Void
    {
        if (textDisplay != null) 
            textDisplay.setFocus()
        else 
        super.setFocus();
    }
    
    /**
	* 当皮肤不为ISkinPartHost时，创建TextDisplay显示对象
	*/
    private function createTextDisplay() : Void
    {
        
    }
    
    /**
	* @inheritDoc
	*/
    override private function removeSkinParts() : Void
    {
        if (textDisplay == null) 
            return;
        partRemoved("textDisplay", textDisplay);
        removeFromDisplayList(cast(textDisplay, DisplayObject));
        textDisplay = null;
    }
    
    /**
	* textDisplay附加
	*/
    private function textDisplayAdded() : Void
    {
        var newTextDisplayProperties : Dynamic = { };
        var richEditableText : EditableText = cast(textDisplay, EditableText);
        
        if (textDisplayProperties.displayAsPassword != null) 
        {
            textDisplay.displayAsPassword = textDisplayProperties.displayAsPassword;
            newTextDisplayProperties.displayAsPassword = true;
        }
        
        if (textDisplayProperties.textColor != null) 
        {
            textDisplay.textColor = textDisplayProperties.textColor;
            newTextDisplayProperties.textColor = true;
        }
        
        if (textDisplayProperties.editable != null) 
        {
            textDisplay.editable = textDisplayProperties.editable;
            newTextDisplayProperties.editable = true;
        }
        
        if (textDisplayProperties.maxChars != null) 
        {
            textDisplay.maxChars = textDisplayProperties.maxChars;
            newTextDisplayProperties.maxChars = true;
        }
        
        if (textDisplayProperties.maxHeight != null) 
        {
            textDisplay.maxHeight = textDisplayProperties.maxHeight;
            newTextDisplayProperties.maxHeight = true;
        }
        
        if (textDisplayProperties.maxWidth != null) 
        {
            textDisplay.maxWidth = textDisplayProperties.maxWidth;
            newTextDisplayProperties.maxWidth = true;
        }
        
        if (textDisplayProperties.restrict != null) 
        {
            textDisplay.restrict = textDisplayProperties.restrict;
            newTextDisplayProperties.restrict = true;
        }
        
        if (textDisplayProperties.selectable != null) 
        {
            textDisplay.selectable = textDisplayProperties.selectable;
            newTextDisplayProperties.selectable = true;
        }
        
        if (textDisplayProperties.text != null) 
        {
            textDisplay.text = textDisplayProperties.text;
            newTextDisplayProperties.text = true;
        }
        
        if (textDisplayProperties.selectionBeginIndex != null) 
        {
            textDisplay.setSelection(textDisplayProperties.selectionBeginIndex,
                    textDisplayProperties.selectionEndIndex);
        }
        if (textDisplayProperties.widthInChars != null && richEditableText != null) 
        {
            richEditableText.widthInChars = textDisplayProperties.widthInChars;
            newTextDisplayProperties.widthInChars = true;
        }
        if (textDisplayProperties.heightInLines != null && richEditableText != null) 
        {
            richEditableText.heightInLines = textDisplayProperties.heightInLines;
            newTextDisplayProperties.heightInLines = true;
        }
        
        textDisplayProperties = newTextDisplayProperties;
    }
    /**
	* textDisplay移除
	*/
    private function textDisplayRemoved() : Void
    {
        var newTextDisplayProperties : Dynamic = { };
        var richEditableText : EditableText = cast(textDisplay, EditableText);
        
        if (textDisplayProperties.displayAsPassword) 
        {
            newTextDisplayProperties.displayAsPassword = textDisplay.displayAsPassword;
        }
        
        if (textDisplayProperties.textColor) 
        {
            newTextDisplayProperties.textColor = textDisplay.textColor;
        }
        
        if (textDisplayProperties.editable) 
        {
            newTextDisplayProperties.editable = textDisplay.editable;
        }
        
        if (textDisplayProperties.maxChars) 
        {
            newTextDisplayProperties.maxChars = textDisplay.maxChars;
        }
        
        if (textDisplayProperties.maxHeight) 
        {
            newTextDisplayProperties.maxHeight = textDisplay.maxHeight;
        }
        
        if (textDisplayProperties.maxWidth) 
        {
            newTextDisplayProperties.maxWidth = textDisplay.maxWidth;
        }
        
        if (textDisplayProperties.restrict) 
        {
            newTextDisplayProperties.restrict = textDisplay.restrict;
        }
        
        if (textDisplayProperties.selectable) 
        {
            newTextDisplayProperties.selectable = textDisplay.selectable;
        }
        
        if (textDisplayProperties.text) 
        {
            newTextDisplayProperties.text = textDisplay.text;
        }
        
        if (textDisplayProperties.heightInLines && richEditableText != null) 
        {
            newTextDisplayProperties.heightInLines = richEditableText.heightInLines;
        }
        
        if (textDisplayProperties.widthInChars && richEditableText != null) 
        {
            newTextDisplayProperties.widthInChars = richEditableText.widthInChars;
        }
        
        textDisplayProperties = newTextDisplayProperties;
    }
    /**
	* textDisplay文字改变事件
	*/
    private function textDisplay_changeHandler(event : Event) : Void
    {
        invalidateDisplayList();
        dispatchEvent(event);
    }
    /**
	* textDisplay文字即将改变事件
	*/
    private function textDisplay_changingHandler(event : TextEvent) : Void
    {
        
        var newEvent : Event = event.clone();
        dispatchEvent(newEvent);
        if (newEvent.isDefaultPrevented()) 
            event.preventDefault();
    }
}


