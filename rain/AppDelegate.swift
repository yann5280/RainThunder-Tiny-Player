//
//  AppDelegate.swift
//  rain
//
//  Created by Frédéric Harper on 2020-08-22.
//  fred.dev

import Cocoa
import AVFoundation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    let menu = NSMenu()
    let menuItem = NSMenuItem()
    let statusSlider = NSSlider(value: 0.7, minValue: 0.0, maxValue: 1.0, target: nil, action: nil)
    var rainSound: AVAudioPlayer?
    
    
    //Run when the application finish loading
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        menu.delegate = self;
        
        if let button = statusItem.button {
            statusSlider.setFrameSize(NSSize(width: 160, height: 35))
            
            button.image = NSImage(named:NSImage.Name("StatusBarButtonImage"));
            button.action = #selector(menuActions(_:));
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
            menu.addItem(NSMenuItem(title: "Volume:", action: nil, keyEquivalent: ""))
            menuItem.title = "Slider 1"
            menuItem.view = statusSlider
            menu.addItem(menuItem)
            
            menu.addItem(NSMenuItem(title: "Apply", action: #selector(volC), keyEquivalent: ""))
            
            menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"));
            
        }
    }
    


    //Either play the rainforest sound or show the menu
    @objc func menuActions(_ sender: NSStatusBarButton) {
        let event = NSApp.currentEvent!;
        
        //Trick to show the menu only on right click
        if (event.type == NSEvent.EventType.rightMouseUp) {
            statusItem.menu = menu;
            statusItem.button?.performClick(nil);
        }
        else {
        
            //Never played before
            if (rainSound == nil) {
                let path = Bundle.main.path(forResource: "RainAndThunder.mp3", ofType:nil)!
                let url = URL(fileURLWithPath: path)

                do {
                    rainSound = try AVAudioPlayer(contentsOf: url);
                    rainSound?.numberOfLoops = -1;
                } catch {
                    NSLog("wtf")
                }
            }
            
            //Play or stop
            if(rainSound?.isPlaying == true) {
                rainSound?.stop();
            }
            else {
                rainSound?.volume = Float(statusSlider.doubleValue)
                rainSound?.play();
            }
        }
    }
    
    //Run when the meny close: trick to show the menu only on right click
    @objc func menuDidClose(_ menu: NSMenu) {
        statusItem.menu = nil;
     }
    
    @objc func volC(_ sender: NSSlider){
        if (rainSound == nil) {
            let path = Bundle.main.path(forResource: "RainAndThunder.mp3", ofType:nil)!
            let url = URL(fileURLWithPath: path)

            do {
                rainSound = try AVAudioPlayer(contentsOf: url);
                rainSound?.numberOfLoops = -1;
            } catch {
                NSLog("wtf")
            }
        }
        
        rainSound?.volume = Float(statusSlider.doubleValue)
        rainSound?.stop();
        rainSound?.play();
    }
}
