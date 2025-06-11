package scripts;

import com.stencyl.graphics.G;
import com.stencyl.graphics.BitmapWrapper;

import com.stencyl.behavior.Script;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.ActorScript;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;

import com.stencyl.models.Actor;
import com.stencyl.models.GameModel;
import com.stencyl.models.actor.Animation;
import com.stencyl.models.actor.ActorType;
import com.stencyl.models.actor.Collision;
import com.stencyl.models.actor.Group;
import com.stencyl.models.Scene;
import com.stencyl.models.Sound;
import com.stencyl.models.Region;
import com.stencyl.models.Font;
import com.stencyl.models.Joystick;

import com.stencyl.Engine;
import com.stencyl.Input;
import com.stencyl.Key;
import com.stencyl.utils.Utils;

import openfl.ui.Mouse;
import openfl.display.Graphics;
import openfl.display.BlendMode;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.TouchEvent;
import openfl.net.URLLoader;

import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2Fixture;
import box2D.dynamics.joints.B2Joint;
import box2D.collision.shapes.B2Shape;

import motion.Actuate;
import motion.easing.Back;
import motion.easing.Cubic;
import motion.easing.Elastic;
import motion.easing.Expo;
import motion.easing.Linear;
import motion.easing.Quad;
import motion.easing.Quart;
import motion.easing.Quint;
import motion.easing.Sine;

import com.stencyl.graphics.shaders.BasicShader;
import com.stencyl.graphics.shaders.GrayscaleShader;
import com.stencyl.graphics.shaders.SepiaShader;
import com.stencyl.graphics.shaders.InvertShader;
import com.stencyl.graphics.shaders.GrainShader;
import com.stencyl.graphics.shaders.ExternalShader;
import com.stencyl.graphics.shaders.InlineShader;
import com.stencyl.graphics.shaders.BlurShader;
import com.stencyl.graphics.shaders.SharpenShader;
import com.stencyl.graphics.shaders.ScanlineShader;
import com.stencyl.graphics.shaders.CSBShader;
import com.stencyl.graphics.shaders.HueShader;
import com.stencyl.graphics.shaders.TintShader;
import com.stencyl.graphics.shaders.BloomShader;



class SceneEvents_2 extends SceneScript
{
	public var _intendedCameraX:Float;
	public var _intendedCameraY:Float;
	public var _currentCameraX:Float;
	public var _currentCameraY:Float;
	public var _ScrollSpeed:Float;
	
	
	public function new(dummy:Int, dummy2:Engine)
	{
		super();
		nameMap.set("intendedCameraX", "_intendedCameraX");
		_intendedCameraX = 0.0;
		nameMap.set("intendedCameraY", "_intendedCameraY");
		_intendedCameraY = 0.0;
		nameMap.set("currentCameraX", "_currentCameraX");
		_currentCameraX = 0.0;
		nameMap.set("currentCameraY", "_currentCameraY");
		_currentCameraY = 0.0;
		nameMap.set("Scroll Speed", "_ScrollSpeed");
		_ScrollSpeed = 0.0;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		loopSound(getSound(86));
		
		/* ======================== When Creating ========================= */
		_intendedCameraX = asNumber(getActor(15).getXCenter());
		propertyChanged("_intendedCameraX", _intendedCameraX);
		_intendedCameraY = asNumber(getActor(15).getYCenter());
		propertyChanged("_intendedCameraY", _intendedCameraY);
		_currentCameraX = asNumber(_intendedCameraX);
		propertyChanged("_currentCameraX", _currentCameraX);
		_currentCameraY = asNumber(_intendedCameraY);
		propertyChanged("_currentCameraY", _currentCameraY);
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				_intendedCameraX = asNumber(getActor(15).getXCenter());
				propertyChanged("_intendedCameraX", _intendedCameraX);
				_intendedCameraY = asNumber(getActor(15).getYCenter());
				propertyChanged("_intendedCameraY", _intendedCameraY);
				if(!(_currentCameraX == _intendedCameraX))
				{
					if(!(Math.abs(_ScrollSpeed) == 0))
					{
						if((_currentCameraX < (_intendedCameraX - _ScrollSpeed)))
						{
							_intendedCameraX += Math.abs(_ScrollSpeed);
							propertyChanged("_intendedCameraX", _intendedCameraX);
						}
						else if((_currentCameraX > (_intendedCameraX + _ScrollSpeed)))
						{
							_intendedCameraX -= Math.abs(_ScrollSpeed);
							propertyChanged("_intendedCameraX", _intendedCameraX);
						}
						else
						{
							_currentCameraX = asNumber(_intendedCameraX);
							propertyChanged("_currentCameraX", _currentCameraX);
						}
					}
					else
					{
						_currentCameraX = asNumber(_intendedCameraX);
						propertyChanged("_currentCameraX", _currentCameraX);
					}
				}
				if(!(_currentCameraY == _intendedCameraY))
				{
					if(!(Math.abs(_ScrollSpeed) == 0))
					{
						if((_currentCameraY < (_intendedCameraY - _ScrollSpeed)))
						{
							_intendedCameraX += Math.abs(_ScrollSpeed);
							propertyChanged("_intendedCameraX", _intendedCameraX);
						}
						else if((_currentCameraY > (_intendedCameraY + _ScrollSpeed)))
						{
							_intendedCameraX -= Math.abs(_ScrollSpeed);
							propertyChanged("_intendedCameraX", _intendedCameraX);
						}
						else
						{
							_currentCameraY = asNumber(_intendedCameraY);
							propertyChanged("_currentCameraY", _currentCameraY);
						}
					}
					else
					{
						_currentCameraY = asNumber(_intendedCameraY);
						propertyChanged("_currentCameraY", _currentCameraY);
					}
				}
				engine.moveCamera(_currentCameraX, _currentCameraY);
			}
		});
		
		/* ======================== Specific Actor ======================== */
		addCollisionListener(getActor(15), function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && (getActor(2) == event.otherActor))
			{
				playSound(getSound(70));
				recycleActor(getActor(2));
				recycleActor(getActor(10));
				recycleActor(getActor(7));
			}
		});
		
		/* ======================== Specific Actor ======================== */
		addCollisionListener(getActor(15), function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && (getActor(8) == event.otherActor))
			{
				playSound(getSound(70));
				recycleActor(getActor(8));
				recycleActor(getActor(5));
				recycleActor(getActor(9));
			}
		});
		
		/* ======================== Specific Actor ======================== */
		addCollisionListener(getActor(15), function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && (getActor(14) == event.otherActor))
			{
				playSound(getSound(70));
				recycleActor(getActor(14));
				recycleActor(getActor(11));
				recycleActor(getActor(12));
				recycleActor(getActor(13));
			}
		});
		
		/* ======================== Specific Actor ======================== */
		addActorEntersRegionListener(getRegion(0), function(a:Actor, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAs(getActor(15), a))
			{
				stopAllSounds();
				playSound(getSound(91));
				switchScene(GameModel.get().scenes.get(4).getID(), null, createCrossfadeTransition(3));
			}
		});
		
		/* ======================== Specific Actor ======================== */
		addActorEntersRegionListener(getRegion(1), function(a:Actor, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAs(getActor(15), a))
			{
				stopAllSounds();
				playSound(getSound(91));
				switchScene(GameModel.get().scenes.get(4).getID(), null, createCrossfadeTransition(3));
			}
		});
		
		/* ======================== Specific Actor ======================== */
		addActorEntersRegionListener(getRegion(2), function(a:Actor, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAs(getActor(15), a))
			{
				stopAllSounds();
				playSound(getSound(91));
				switchScene(GameModel.get().scenes.get(4).getID(), null, createCrossfadeTransition(3));
			}
		});
		
		/* ======================== Group & Group ========================= */
		addSceneCollisionListener(getActorGroup(6).ID + 1000000, getActorGroup(5).ID + 1000000, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				playSound(getSound(74));
				getActor(15).say("Health Manager", "_customBlock_Damage", [20]);
			}
		});
		
		/* ======================== Group & Group ========================= */
		addSceneCollisionListener(getActorGroup(5).ID + 1000000, getActorGroup(0).ID + 1000000, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				playSound(getSound(71));
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}