'*******************************************************************************
' Goal:     Check the resistors and capacitors in Hes-so stock or not
'-------------------------------------------------------------------------------
' Comments: If a "supplier 1" has been defined in a component, this part
'           will not be checked !
'
'-------------------------------------------------------------------------------
' Caution:  The data source has to be the file with path to the parts list.
'-------------------------------------------------------------------------------
' Author:   pascal dot sartoretti at hevs dot ch
'-------------------------------------------------------------------------------
' Revision: 1.0 - original 07-2016
'*******************************************************************************
Dim outputText
Dim count
dataBase = "P:\Library\AltiumLib\Stock HESSO\hesso_stock.accdb"

Function FindComp(ByRef Sheet )
connStr = "Provider=Microsoft.ACE.OLEDB.12.0; Data Source=" & dataBase
Set objConn = CreateObject("ADODB.Connection")
'Open Connection to access
objConn.open connStr

'Define recordset and SQL query

    ' Look for components only in the current schematic
    Iterator = Sheet.SchIterator_Create
    Iterator.AddFilter_ObjectSet(MkSet(eSchComponent))
    Err.Number = 0
    On Error Resume Next
    Err.clear
    ' Initialize the robots in Schematic editor.
    SchServer.ProcessControl.PreProcess Sheet, ""
        Component = Iterator.FirstSchObject
        'Bug workaround on hierachical design
        If Err.Number <> 0 Then
           Err.Number = 0
           Exit Function
        end if
        ' do for each component on a page SCH
        Do While not(Component is Nothing)
                PIterator = Component.SchIterator_Create
                PIterator.AddFilter_ObjectSet(MkSet(eParameter))

                ImplIterator = Component.SchIterator_Create
                ImplIterator.AddFilter_ObjectSet(MkSet(eImplementation))

                ordered = 0
                Parameter = PIterator.FirstSchObject
                '***********************************************************
                ' Just Get if any supplier exist
                '***********************************************************
                ParameterSupplier = PIterator.FirstSchObject
                ordered = 0
                Do While not(ParameterSupplier is Nothing)
                     if ParameterSupplier.Name = "Supplier 1" then
                        ordered = 1
                     end if
                     Set ParameterSupplier = PIterator.NextSchObject
                Loop
                Parameter = PIterator.FirstSchObject
                Component = Parameter.Container
                Do While not(Parameter is Nothing)
                    ' // Check for parameters choosen
                    If ((Component.ComponentDescription = "Resistor") and cbResistors.State = cbChecked and (Parameter.Name = "Value")) or _
                     ((Component.ComponentDescription = "Capacitor") and cbCapacitors.State = cbChecked and (Parameter.Name = "Value")) or _
                     ((Component.ComponentDescription = "Inductor") and cbCapacitors.State = cbChecked and (Parameter.Name = "Value")) or _
                     (cbOthers.State = cbChecked and (Parameter.Name = "Value"))Then


                         '***********************************************************
                         ' Just Get pattern for PCB
                         '***********************************************************
                         SchImplementation = ImplIterator.FirstSchObject
                         do While not(SchImplementation is Nothing)
                             ' check which PCB model is used for the Sch Component.
                             If SchImplementation.ModelType = "PCBLIB" Then
                                If SchImplementation.IsCurrent Then
                                     '        ShowMessage(SchImplementation.ModelName)
                                   pcbModel = SchImplementation.ModelName
                                   pcbModelForDB = Replace(pcbModel,".","_")
                                   exit do
                                end if
                                SchImplementation = ImplIterator.NextSchObject
                             end if
                         Loop
                          resVal = Parameter.Text
                          on error resume next
                         '***********************************************************
                         ' SQL query is here
                         '***********************************************************
                          Set rs = objConn.execute("SELECT [" & pcbModelForDB &"] FROM [" & Component.DesignItemID & "]")
                          'ShowMessage("Integrated Model : "  & Component.DesignItemID)
                          'ShowMessage("Component Description : "  & Component.ComponentDescription)
                          'msgbox Component.ComponentDescription
                          found = 0
                          do
                             check = rs.Fields(0)
                             'if(resVal = "BAS16") then
                             '   ShowMessage("COMP to check: "  & resVal & "in " & pcbModel & "from " & Component.DesignItemID& "found : " & check)
                             'end if
                             'ShowMessage("COMP to check: "  & resVal & "found : " & check)
                                                         
                             if(check = resVal) then
                              '  ShowMessage("Resistor : "  & resVal & "ohms IS in stock")

                                found = 1
                             end if
                             rs.MoveNext
                          Loop While ((not rs.EOF) and (found = 0))
                          if (found = 0) and (ordered = 0) then
                              if((Parameter.Text <> "TBD") or (cbTBD.state = cbUnchecked)) then
                                Count = Count + 1
                                ' ShowMessage("Resistor : "  & resVal & "ohms not in stock")
                                if Component.ComponentDescription = "Resistor" then
                                  resList = resList & Component.Designator.Text & ": " & resVal & " - case: " & pcbModel & vbCrLf
                                else
                                  resList = resList & Component.Designator.Text & ": " & resVal & " - case: " & pcbModel & vbCrLf
                                end if
                               end if
                          end if
                        '//SchServer.RobotManager.SendMessage(Parameter.I_ObjectAddress, c_BroadCast, SCHM_BeginModify, c_NoEventData);
                        '//Parameter.Text := UserDefined;
                        '//SchServer.RobotManager.SendMessage(Parameter.I_ObjectAddress, c_BroadCast, SCHM_EndModify  , c_NoEventData);
                    End if
                    Set Parameter = PIterator.NextSchObject
                Loop
                Component.SchIterator_Destroy(PIterator)
            set Component = Iterator.NextSchObject
        Loop
        Sheet.SchIterator_Destroy(Iterator)

    '// Clean up robots in Schematic editor.
    SchServer.ProcessControl.PostProcess Sheet, ""
    outputText = outputText & resList
    'ShowMessage("Contain "+ IntToStr(Count) + " components not in Hes-so stock:" & vbCrLf & resList)
    ' // Refresh the screen
    Sheet.GraphicallyInvalidate
    'Close connection and release objects
    objConn.Close
    Set rs = Nothing
    Set objConn = Nothing
End Function




Sub Check_Hesso_Stock (byRef sender)
 Dim I
 Dim   Doc
Dim    CurrentSch
Dim    SchDocument
Dim    Project
    countSchFiles = 0
    Project = GetWorkspace.DM_FocusedProject
    Project.DM_Compile

    ' selected or all documents within the project
    For I = 0 to (Project.DM_LogicalDocumentCount - 1)

        Doc = Project.DM_LogicalDocuments(I)
        If Doc.DM_DocumentKind = "SCH" Then
           countSchFiles = countSchFiles + 1
           SchDocument = Client.OpenDocument("Sch", Doc.DM_FullPath)

               Client.ShowDocument(SchDocument)
               CurrentSch = SchServer.GetCurrentSchDocument
               FindComp CurrentSch
        end if
    Next
    if(countSchFiles = 0) then
       ShowMessage("Select a project with schematic files ! ")
    else
      ' ShowMessage("Contain "+ IntToStr(Count) + " components not in stock:" & vbCrLf& vbCrLf & outputText)
       MsgBox "Contain "+ IntToStr(Count) + " components not in stock:" & vbCrLf& vbCrLf & outputText,,"Result for Check (use copy/paste)"
    end if
End sub


Sub btOkClick(Sender)
      Call Check_Hesso_stock(Sender)
      Close
End Sub

Sub btCancelClick(Sender)
    Close
End Sub

Sub cbOthersClick(Sender)
   if(cbOthers.state = cbChecked) then
      cbResistors.state = cbChecked
      cbCapacitors.state = cbChecked
      cbInductors.state = cbChecked
   end if
End Sub

Sub cbResistorsClick(Sender)
    if cbResistors.state = cbUnchecked then
      cbOthers.state = Unchecked
    end if
End Sub

Sub cbCapacitorsClick(Sender)
    if cbCapacitors.state = cbUnchecked then
      cbOthers.state = Unchecked
    end if
End Sub

Sub Form1Create(Sender)
    lblDatabase.text = dataBase
End Sub

Sub cbInductorsClick(Sender)
    if cbInductors.state = cbUnchecked then
      cbOthers.state = Unchecked
    end if

End Sub

Sub btOpenDialogClick(Sender)
     if OpenDialog1.Execute then
      dataBase = OpenDialog1.FileName
      lblDatabase.text = dataBase
     else
     end if
End Sub


