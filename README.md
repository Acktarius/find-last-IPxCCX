# find-last-IPxCCX

### find last ip and crosscheck if Conceal Assistant is broadcasting
***only tested for UBUNTU 22.04 LTS***

download **find-last-IPxCCX.sh**,

then 

`chmod 755 find-last-IPxCCX.sh`

ideally would be place in the **/opt/conceal-toolbox** folder

**Step 1:** with your CCX-BOX NOT connected to the network.

* run :
`./find-last-IPxCCX.sh`
(a first scan of your local network is done)

**Step 2 :** WITHIN 60seconds, plug and boot your CCX-BOX.

(a second scan of your local network is done)
the newly detected IP will be given to you and also the option to go on
firefox visit the Conceal-Assistant page if the port is correctly open.
