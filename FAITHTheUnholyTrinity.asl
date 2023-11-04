state("FAITH")
{
    int CurRoom : 0x6C4DB8;
    byte inCutscene : 0x004B477C, 0x0, 0x68, 0x10, 0x80;
}

init
{
    vars.doneMaps = new List<string>(); 
    vars.CurRoomToString = "";

	vars.sheepcounter = "";
	
}

startup
{
    settings.Add("Faith", true, "Faith: The Unholy Trinity");
    settings.Add("Ch1", true, "Faith: Chapter One", "Faith");
    settings.Add("Ch2", true, "Faith: Chapter Two", "Faith");
    settings.Add("Ch3", true, "Faith: Chapter Three", "Faith");

    var tB = (Func<string, string, string, Tuple<string, string, string>>) ((elmt1, elmt2, elmt3) => { return Tuple.Create(elmt1, elmt2, elmt3); });
    var sB = new List<Tuple<string, string, string>>
    {
        //Chapter I
        tB("Ch1", "410", "Start of Chapter 1"),
        tB("Ch1", "432", "Entering Worn-Down, Ugly, Brown, Shack"),
        tB("Ch1", "454", "Entering Worn-Down, Ugly, Red, House"),
        tB("Ch1", "406", "Amy climbs into bed for cuddles"),
        tB("Ch1", "467", "Entering Attic"),
        tB("Ch1", "405", "Title Card"),

        //Chapter II
        tB("Ch2", "481", "Beginning Room"),
        tB("Ch2", "517", "Descending beneath Chapel"),
        tB("Ch2", "525", "Spider transformation complete"),
        tB("Ch2", "574", "Title Card"),

        //Chapter III
        tB("Ch3", "381", "Open Chapter III / Nightmare 1"),
        tB("Ch3", "110", "Wake up Day 1"),
        tB("Ch3", "170", "Clinic Basement Stretcher"),
        tB("Ch3", "111", "Nightmare 2"),
        tB("Ch3", "116", "Wake up Day 2"),
        tB("Ch3", "180", "Inside Lisas room + Lisa fight"),
        tB("Ch3", "244", "Tiffany boss intro and fight"),
        tB("Ch3", "130", "Nightmare 3"),
        tB("Ch3", "133", "Wake up Day 3"),
        tB("Ch3", "248", "School entrance"),
        tB("Ch3", "388", "Tripping Balls cutscene"),
        tB("Ch3", "141", "Nightmare section again right after tripping balls cutscene"),
        tB("Ch3", "266", "Weird cult section underneath the school after tripping balls"),
        // tB("Ch3", "325", "First Gary battle before the end of the game"), Changed To Profane Sabbath
        tB("Ch3", "150", "Profane Sabbath"),
        
        //Ending I & II
        tB("Ch3", "338", "Second Gary fight for Ending II which is right before the final end of the game and Ending specific to II"),
        tB("Ch3", "343", "The Ending for Ending II right before last automatic split triggers. Choosing to leave with Fr. Garcia"),

        //Ending I & III
        tB("Ch3", "169", "Empty Clinic"),
        tB("Ch3", "247", "Empty Apartment"),
        tB("Ch3", "320", "Empty Apartment"),

        //Ending II
        tB("Ch3", "336", "Ending"),

        //Ending III
        tB("Ch3", "354", "Grabbing key in basement of protagonists house during lightning strike - Ending specific to III I think"),
        tB("Ch3", "350", "Going inside the room locked up with all the crosses in the protagonists house for Ending III"),
        tB("Ch3", "366", "Ending placard for Ending III. Needs to have final time split here"),

        tB("Ch3", "346", "Title Card"),
    };
        foreach (var s in sB) settings.Add(s.Item2, true, s.Item3, s.Item1);   

	if (timer.CurrentTimingMethod == TimingMethod.RealTime)
	{        
		var timingMessage = MessageBox.Show (
			"This game uses Time without Loads (Game Time) as the main timing method.\n"+
			"LiveSplit is currently set to show Real Time (RTA).\n"+
			"Would you like to set the timing method to Game Time?",
			"LiveSplit | Faith The Unholy Trinity",
			MessageBoxButtons.YesNo,MessageBoxIcon.Question
		);
		if (timingMessage == DialogResult.Yes)
		{
			timer.CurrentTimingMethod = TimingMethod.GameTime;
		}
	}

    vars.LoadValues = new List<int>
    {
        410,
        411,
        406,
        476,
        485,
        573,
        572,
        562,
        567,
        381,
        382,
        384,
        110,
        92,
        400,
        387,
        386,
        385,
        36,
        383,
        116,
        210,
        244,
        389,
        75,
        76,
        388,
        327,
        340,
        341,
        342,
        343,
        345,
        133,
        93,
        361,
        362,
        363,
        364,
        365,
        366


    };

     vars.SetTextComponent = (Action<string, string>)((id, text) =>
    {
        var textSettings = timer.Layout.Components.Where(x => x.GetType().Name == "TextComponent").Select(x => x.GetType().GetProperty("Settings").GetValue(x, null));
        var textSetting = textSettings.FirstOrDefault(x => (x.GetType().GetProperty("Text1").GetValue(x, null) as string) == id);
        if (textSetting == null)
        {
        var textComponentAssembly = Assembly.LoadFrom("Components\\LiveSplit.Text.dll");
        var textComponent = Activator.CreateInstance(textComponentAssembly.GetType("LiveSplit.UI.Components.TextComponent"), timer);
        timer.Layout.LayoutComponents.Add(new LiveSplit.UI.Components.LayoutComponent("LiveSplit.Text.dll", textComponent as LiveSplit.UI.Components.IComponent));

        textSetting = textComponent.GetType().GetProperty("Settings", BindingFlags.Instance | BindingFlags.Public).GetValue(textComponent, null);
        textSetting.GetType().GetProperty("Text1").SetValue(textSetting, id);
        }

        if (textSetting != null)
        textSetting.GetType().GetProperty("Text2").SetValue(textSetting, text);
    });
	settings.Add("sheep_count", true, "Sheep Count");
}

update
{
    vars.CurRoomToString = current.CurRoom.ToString();
    print(vars.CurRoomToString);
		if (settings["sheep_count"]) {vars.SetTextComponent("RoomID", (current.CurRoom).ToString()); }

}

start
{
    return (settings[vars.CurRoomToString]);
}

onStart
{
    vars.doneMaps.Add(vars.CurRoomToString);
}

split
{
    if (settings[vars.CurRoomToString] && (!vars.doneMaps.Contains(vars.CurRoomToString)))
    {
        vars.doneMaps.Add(vars.CurRoomToString);
        return true;
    }
}

isLoading
{
    return (vars.LoadValues.Contains(current.CurRoom));
}

onReset
{
    vars.doneMaps.Clear();
}