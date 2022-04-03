extends Node

var score_file = "user://highscore.save"
var enable_sound = true
var enable_music = true

var planets_per_level = 11

var admob = null
var real_ads = false
var banner_top = false
var ad_banner_id = ""
var ad_interstitial_id = ""
var enable_ads = true

func _ready():
	if Engine.has_singleton("AdMob"):
		admob = Engine.get_singleton("AdMob")
		admob.init(real_ads, get_instance_id())
		admob.loadBanner(ad_banner_id, banner_top)
		admob.loadInterstitial(ad_interstitial_id)
		
func show_ad_banner():
	if admob and enable_ads:
		admob.showBanner()
		
func hide_ad_banner():
	if admob:
		admob.hideBanner()
		
func show_intersitial():
	if admob and enable_ads:
		admob.showInterstitial()
		
func _on_interstitial_closed():
	if admob and enable_ads:
		show_ad_banner()
		
