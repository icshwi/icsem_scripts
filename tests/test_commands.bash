# Automatic test of EVG and EVR
###

# We can check the EVG and EVR link status and the link clock setting.
echo caget MTCA424-EVR0:Link-Sts
caget MTCA424-EVR0:Link-Sts
echo caget MTCA424-EVR0:Link-Clk-I
caget MTCA424-EVR0:Link-Clk-I
echo caget test-EVG0:EvtClk-Frequency-RB
caget test-EVG0:EvtClk-Frequency-RB

# Change the wrong clock setting on EVR, then we expect that the link status will be Fail.  
echo caput MTCA424-EVR0:Link-Clk-SP 100
caput MTCA424-EVR0:Link-Clk-SP 100
echo caget MTCA424-EVR0:Link-Clk-I
caget MTCA424-EVR0:Link-Clk-I
echo caget MTCA424-EVR0:Link-Sts
caget MTCA424-EVR0:Link-Sts

# There is a link heartbeat counter that gets updated aproximately every 1.3 s when the link is off. Camonitor it to check its functionality.
echo camonitor MTCA424-EVR0:Cnt-LinkTimo-I
(cmdpid=$BASHPID; (sleep 5; kill $cmdpid) & exec camonitor MTCA424-EVR0:Cnt-LinkTimo-I)

# Revert it back to the proper clock setting, and the link status will be OK.
echo caput MTCA424-EVR0:Link-Clk-SP 88.0525
caput MTCA424-EVR0:Link-Clk-SP 88.0525
echo caget MTCA424-EVR0:Link-Sts
caget MTCA424-EVR0:Link-Sts

# Monitor the Event counter with 14 and check the time difference between counters, e.g., 278 and 279, is 0.071429s, i.e., 14 Hz.
echo camonitor MTCA424-EVR0:Event-14-Cnt-I
#(cmdpid=$BASHPID; (sleep 3; kill $cmdpid) & exec camonitor MTCA424-EVR0:Event-14-Cnt-I)

# Enable the software event
echo caput test-EVG0:SoftEvt-Enable-Sel "Enabled"
caput test-EVG0:SoftEvt-Enable-Sel "Enabled"

#See number of counts
echo caget MTCA424-EVR0:Event-1-Cnt-I
caget MTCA424-EVR0:Event-1-Cnt-I

#Send the event from the EVG
echo caput test-EVG0:SoftEvt-EvtCode-SP 1
caput test-EVG0:SoftEvt-EvtCode-SP 1
sleep 10

#Count the event
echo caget MTCA424-EVR0:Event-1-Cnt-I
caget MTCA424-EVR0:Event-1-Cnt-I

# Change the width time of the pulse generator 0 from 10 ms to 50 ms
echo caput MTCA424-EVR0:Pul0-Width-SP 50000
caput MTCA424-EVR0:Pul0-Width-SP 50000
sleep 10

# Revert
echo caput MTCA424-EVR0:Pul0-Width-SP 10000
caput MTCA424-EVR0:Pul0-Width-SP 10000

# In the EVG host, attach the soft sequence to a specific hardware sequence
echo caput test-EVG0:SoftSeq-1-Unload-Cmd 1
caput test-EVG0:SoftSeq-1-Unload-Cmd 1
echo caput test-EVG0:SoftSeq-1-Load-Cmd 1
caput test-EVG0:SoftSeq-1-Load-Cmd 1

# Set engineering units for the timestamping
echo caput test-EVG0:SoftSeq-1-TsInpMode-Sel EGU
caput test-EVG0:SoftSeq-1-TsInpMode-Sel EGU
echo caput test-EVG0:SoftSeq-1-TsResolution-Sel ms
caput test-EVG0:SoftSeq-1-TsResolution-Sel ms

# Set the trigger source for the sequence as software and enable it
echo caput test-EVG0:SoftSeq-1-TrigSrc-Sel Software
caput test-EVG0:SoftSeq-1-TrigSrc-Sel Software
echo caput test-EVG0:SoftSeq-1-Enable-Cmd 1
caput test-EVG0:SoftSeq-1-Enable-Cmd 1

# Set up the sequence content, corresponding timestamps and masks
# The timestamps are specified in milliseconds, as set before
echo caput -a test-EVG0:SoftSeq-1-EvtCode-SP 3 1 2 3
caput -a test-EVG0:SoftSeq-1-EvtCode-SP 3 1 2 3
echo caput -a test-EVG0:SoftSeq-1-Timestamp-SP 3 1000 2000 3000
caput -a test-EVG0:SoftSeq-1-Timestamp-SP 3 1000 2000 3000
echo caput -a test-EVG0:SoftSeq-1-EvtMask-SP 3 0 0 0
caput -a test-EVG0:SoftSeq-1-EvtMask-SP 3 0 0 0

# Commit the sequence to hardware
echo caput test-EVG0:SoftSeq-1-Commit-Cmd 1
caput test-EVG0:SoftSeq-1-Commit-Cmd 1

# In the EVR host, set the record to get timestamp from system time (OS clock)
echo caput MTCA424-EVR0:Event-1-SP.TSE 0
caput MTCA424-EVR0:Event-1-SP.TSE 0
echo caput MTCA424-EVR0:Event-2-SP.TSE 0
caput MTCA424-EVR0:Event-2-SP.TSE 0
echo caput MTCA424-EVR0:Event-3-SP.TSE 0
caput MTCA424-EVR0:Event-3-SP.TSE 0

# Monitor the reception of the events
#(cmdpid=$BASHPID; (sleep 15; kill $cmdpid) & exec camonitor MTCA424-EVR0:Event-1-Cnt-I MTCA424-EVR0:Event-2-Cnt-I MTCA424-EVR0:Event-3-Cnt-I)

# On the EVG host, trigger the sequence
echo caget MTCA424-EVR0:Event-1-Cnt-I MTCA424-EVR0:Event-2-Cnt-I MTCA424-EVR0:Event-3-Cnt-I
caget MTCA424-EVR0:Event-1-Cnt-I MTCA424-EVR0:Event-2-Cnt-I MTCA424-EVR0:Event-3-Cnt-I
echo caput test-EVG0:SoftSeq-1-SoftTrig-Cmd 1
caput test-EVG0:SoftSeq-1-SoftTrig-Cmd 1
sleep 5
echo caget MTCA424-EVR0:Event-1-Cnt-I MTCA424-EVR0:Event-2-Cnt-I MTCA424-EVR0:Event-3-Cnt-I
caget MTCA424-EVR0:Event-1-Cnt-I MTCA424-EVR0:Event-2-Cnt-I MTCA424-EVR0:Event-3-Cnt-I
echo caput test-EVG0:SoftSeq-1-SoftTrig-Cmd 1
caput test-EVG0:SoftSeq-1-SoftTrig-Cmd 1
sleep 5
echo caget MTCA424-EVR0:Event-1-Cnt-I MTCA424-EVR0:Event-2-Cnt-I MTCA424-EVR0:Event-3-Cnt-I
caget MTCA424-EVR0:Event-1-Cnt-I MTCA424-EVR0:Event-2-Cnt-I MTCA424-EVR0:Event-3-Cnt-I
echo caput test-EVG0:SoftSeq-1-SoftTrig-Cmd 1
caput test-EVG0:SoftSeq-1-SoftTrig-Cmd 1
sleep 5
echo caget MTCA424-EVR0:Event-1-Cnt-I MTCA424-EVR0:Event-2-Cnt-I MTCA424-EVR0:Event-3-Cnt-I
caget MTCA424-EVR0:Event-1-Cnt-I MTCA424-EVR0:Event-2-Cnt-I MTCA424-EVR0:Event-3-Cnt-I



# Watch closely to the graph in the CSS OPI screen when enabling Rear Universal Output 33, since in the next event 14 received the SIS8300 will start the data acquisition; since it is not connected, the data acquired is just 0
#caput EVRTEST-EVRMTCA:RearUniv33-Ena-SP "Enabled"

