---
title: Konquerors ViewMode Buttons
author: m6w6
tags: 
- WTF
---

If you, after upgrading to Dapper Drake, are missing your beloved ViewMode
Buttons in Konqueror, locate
`/usr/share/kubuntu-default-settings/kde-profile/default/share/apps/konqueror/konq-kubuntu.rc`
and add the following ToolBar node:
```xml    
<ToolBar newline="false" hidden="false" name="viewModeToolBar" >  
  <text>ViewMode Toolbar</text>  
  <ActionList name="viewmode_toolbar" />  
</ToolBar>
```

Yes, you guessed, this drove me mad ;)
