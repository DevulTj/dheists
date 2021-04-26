--[[
	© 2021 Tony Ferguson, do not share, re-distribute or modify

	without permission of its author ( devultj@gmail.com - Tony Ferguson, http://www.tferguson.co.uk/ )
]]

local HTMLCode = [[

    <!DOCTYPE html>
    <html lang="en-US">
      <head>
        <meta charset="UTF-8">

    <!-- Begin Jekyll SEO tag v2.4.0 -->
    <title>Installation | dheists</title>

    <meta name="generator" content="Jekyll v3.7.3" />
    <meta property="og:title" content="Installation" />
    <meta property="og:locale" content="en_US" />
    <meta name="description" content="A bank robbery system for Garry’s Mod made by DevulTj" />
    <meta property="og:description" content="A bank robbery system for Garry’s Mod made by DevulTj" />
    <link rel="canonical" href="https://devultj.github.io/dheists/" />
    <meta property="og:url" content="https://devultj.github.io/dheists/" />
    <meta property="og:site_name" content="dheists" />
    <script type="application/ld+json">
    {"name":"dHeists","description":"A bank robbery system for Garry’s Mod made by DevulTj","@type":"WebSite","url":"https://devultj.github.io/dheists/","headline":"Installation","@context":"http://schema.org"}</script>
    <!-- End Jekyll SEO tag -->

        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="theme-color" content="#157878">
        <!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">

<!-- Optional theme -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css" integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp" crossorigin="anonymous">

<!-- Latest compiled and minified JavaScript -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
      </head>
      <body>
        <section class="page-header">
          <center><h1 class="project-name">dHeists</h1>
          <h2 class="project-tagline">A bank robbery system for Garry's Mod made by DevulTj</h2>

            <a href="https://www.gmodstore.com/scripts/view/5188/dheists-heist-system-for-darkrp" class="btn">View on gmodstore</a>
            </center>


        </section>

        <section class="container">
          <h2 id="installation">Installation</h2>
    <ol>
      <li>Unzip the addon and place it in your ‘addons’ folder.</li>
      <li>Check the configuration files inside of ‘lua\dheists’.</li>
      <li>If you have any further inquiries regarding installation please send in a support ticket or refer below on how to contact me.</li>
      <li>All configuration options are displayed in the ‘lua\dheists\config’ folder.</li>
    </ol>

    <h2 id="creating-a-zone">Creating a Zone</h2>
    <ol>
      <li>Type /zones (if you have access) to open the Zone List.</li>
      <li>Click Create Zone, it should bring you to a text prompt that will allow you to name the zone to what you desire.</li>
      <li>Re-open /zones, and press on the new Zone you just created.</li>
      <li>You will be in a Zone Editor utility, you’ll be able to spawn objects such as robbable entities (vaults, etc) and then click Save to persist them.</li>
    </ol>

    <h2 id="deleting-a-zone">Deleting a Zone</h2>
    <ol>
      <li>Type /zones to open the Zone List.</li>
      <li>Hover over the red slot to the right of a zone, it’ll show a Delete button.</li>
      <li>Click it.</li>
    </ol>

    <h2 id="spawning-loot-triggers-waypoints">Spawning Loot Triggers (Waypoints)</h2>
    <ol>
      <li>Type /zones to open the Zone List.</li>
      <li>Click Entity Spawner.</li>
      <li>A list will show possible entities you can spawn, such as a Loot Trigger. This will allow your players to locate and sell their goods.</li>
    </ol>


          <footer class="site-footer">
            <span class="site-footer-credits">This page, and dHeists was created by <a href="http://steamcommunity.com/id/Devul">DevulTj</a>.</span>
          </footer>
        </section>


      </body>
    </html>
]]

local FRAME = {}

function FRAME:Init()
    self:StretchToParent( 200, 100, 200, 100 )
    self:SetTitle( "Help" )
    self:MakePopup()
    self:SetSkin( "devUI" )

    self.Loading = self:Add( "DLabel" )
    self.Loading:SetSize( 512, 256 )
    self.Loading:Center()
    self.Loading:SetContentAlignment( 5 )
    self.Loading:SetText( "Loading..." )
    self.Loading:SetFont( "dHeistsLarge" )

    self.HTML = self:Add( "HTML" )
    self.HTML:Dock( FILL )
    self.HTML:SetHTML( HTMLCode )
end

vgui.Register( "dHeistsHelpMenu", FRAME, "DFrame" )

function dHeists.showHelpMenu()
    if IsValid( dHeists.HelpMenu ) then
        dHeists.HelpMenu:Remove()
    end

    dHeists.HelpMenu = vgui.Create( "dHeistsHelpMenu" )
end
