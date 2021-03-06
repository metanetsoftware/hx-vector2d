package geom;

@:dox(show) private typedef Vector2dImpl = {x:Float, y:Float}

/**
	Represents a two dimensional vector.

	@author Mark Knol
**/
@:forward abstract Vector2d(Vector2dImpl) from Vector2dImpl to Vector2dImpl {
	public static function empty() return new Vector2d(0.0, 0.0);
	/** Construct a new vector instance. **/
	public inline function new(x:Float, y:Float) {
		this = {x: x, y: y};
	}

	private var self(get, never):Vector2d;

	private inline function get_self():Vector2d {
		return (this : Vector2d);
	}

	/** Sets component values of `this` values. If `y` is ommited, both components will be set to `x`. **/
	public inline function set(x:Float, y:Float):Vector2d {
		this.x = x;
		this.y = y;
		return this;
	}

	/** Clone `this` vector into new Vector2d instance. **/
	public inline function clone():Vector2d {
		return new Vector2d(this.x, this.y);
	}

	/** Copy component values from `target` vector to `this` vector. **/
	public inline function copy(target:Vector2d):Vector2d {
		this.x = target.x;
		this.y = target.y;
		return this;
	}

	/** Round component values of `this` vector. **/
	public inline function round():Vector2d {
		this.x = Math.fround(this.x);
		this.y = Math.fround(this.y);
		return this;
	}

	/** floor (round down) component values of `this` vector. **/
	public inline function floor():Vector2d {
		this.x = Math.ffloor(this.x);
		this.y = Math.ffloor(this.y);
		return this;
	}

	/** Ceil (round up) component values of `this` vector. **/
	public inline function ceil():Vector2d {
		this.x = Math.fceil(this.x);
		this.y = Math.fceil(this.y);
		return this;
	}

	/** Convert `this` component values to absolute values. **/
	public inline function abs():Vector2d {
		this.x = Math.abs(this.x);
		this.y = Math.abs(this.y);
		return this;
	}

	/** @return Length of this vector  `x*x + y*y`. **/
	public var length(get, set):Float;

	private inline function get_length():Float {
		return this.x * this.x + this.y * this.y;
	}

	private inline function set_length(value:Float):Float {
		var length = get_length();
		if (length == 0) return 0;
		var l = value / length;
		this.x *= l;
		this.y *= l;
		return value;
	}

	/** @return true if given vector is in range `(this-vector).length < range*range` **/
	public function inRange(vector:Vector2d, range:Float):Bool {
		return (self - vector).length < range * range;
	}

	/** @return Distance to given vector. Same as `(this-vector).magnitude` **/
	public function distanceTo(vector:Vector2d):Float {
		return (self - vector).magnitude;
	}

	/** @return Distance of given vectors. Same as `a.distanceTo(b)` **/
	public inline static function distanceOf(a:Vector2d, b:Vector2d):Float {
		return a.distanceTo(b);
	}

	/** @return scalar number of dot product `x * vector.x + y * vector.y`. **/
	public inline function dot(vector:Vector2d):Float {
		var component:Vector2d = self * vector;
		return component.x + component.y;
	}

	/** @return scalar number of vector product `x * vector.y - y * vector.x`. **/
	public inline function vector(vector:Vector2d):Float {
		return this.x * vector.y - this.y * vector.x;
	}

	/** @return new vector unit of this vector `this/magnitude`. **/
	public inline function normalize():Vector2d {
		return self / magnitude;
	}

	/** Obtains the projection of current vector on a given axis. **/
	public inline function projection(to:Vector2d):Float {
		return dot(to.normalize());
	}

	/** Obtain angle of `this` vector. **/
	public function angle():Float {
		return Math.atan2(this.y, this.x);
	}

	/** Obtains the smaller angle (radians) sandwiched from current to given vector. **/
	public inline function angleTo(to:Vector2d):Float {
		// get normalized vectors
		var norm1:Vector2d = normalize();
		var norm2:Vector2d = to.normalize();

		// dot product of vectors to find angle
		var product = norm1.dot(norm2);
		product = Math.min(1, product);
		var angle = Math.acos(product);

		// sides of angle
		if (vector(to) < 0) angle *= -1;

		return angle;
	}

	public function rotateAroundAngle(angle:Float):Vector2d {
		var x = this.x;
		var y = this.y;
		this.x = x * Math.cos(angle) - y * Math.sin(angle);
		this.y = y * Math.cos(angle) + x * Math.sin(angle);
		return this;
	}

	/** Obtains the smaller angle (radians) sandwiched from current to given vector. **/
	public inline function moveTo(angle:Float, distance:Float):Vector2d {
		this.x += Math.cos(angle) * distance;
		this.y += Math.sin(angle) * distance;
		return this;
	}

	/** @return New vector instance that is made from the smallest components of two vectors. **/
	public static function minOf(a:Vector2d, b:Vector2d):Vector2d {
		return a.clone().min(b);
	}

	/** @return New vector instance that is made from the largest components of two vectors. **/
	public static function maxOf(a:Vector2d, b:Vector2d):Vector2d {
		return a.clone().max(b);
	}

	/** @return Sets this vector instance components to the smallest components of given vectors. **/
	public function min(v:Vector2d):Vector2d {
		this.x = Math.min(this.x, v.x);
		this.y = Math.min(this.y, v.y);
		return this;
	}

	/** @return Sets this vector instance components to the largest components of given vectors. **/
	public function max(v:Vector2d):Vector2d {
		this.x = Math.max(this.x, v.x);
		this.y = Math.max(this.y, v.y);
		return this;
	}

	/** Obtains the projection of `this` vector on a given axis. **/
	public inline function polar(magnitude:Float, angle:Float) {
		this.x = magnitude * Math.cos(angle);
		this.y = magnitude * Math.sin(angle);
	}

	/** @return Magnitude of vector (squared length). **/
	public var magnitude(get, set):Float;

	private inline function get_magnitude():Float {
		return Math.sqrt(length);
	}

	private inline function set_magnitude(magnitude:Float):Float {
		polar(magnitude, angle());
		return magnitude;
	}

	/** Invert x component of `this` vector `x *= -1`. **/
	public inline function invertX():Void this.x *= -1;

	/** Invert y component of `this` vector `y *= -1`. **/
	public inline function invertY():Void this.y *= -1;

	/** Invert both component values of `this` vector `this *= -1`. **/
	public inline function invertAssign():Vector2d {
		this.x *= -1;
		this.y *= -1;
		return this;
	}

	/** (new instance) Invert both component values of `this` vector. **/
	@:op(-A) public inline function invert():Vector2d {
		return clone().invertAssign();
	}

	/** Sum given vector to `this` component values. Modifies this instance. Can also be used with `a+=b` operator. **/
	@:commutative @:op(A += B) public inline function addAssign(by:Vector2d):Vector2d {
		this.x += by.x;
		this.y += by.y;
		return this;
	}

	/** Substract given vector from `this` component values. Modifies this instance. Can also be used with `a-=b` operator. **/
	@:commutative @:op(A -= B) public inline function substractAssign(by:Vector2d):Vector2d {
		this.x -= by.x;
		this.y -= by.y;
		return this;
	}

	/** Multiply `this` component values by given vector. Modifies this instance. Can also be used with `a*=b` operator. **/
	@:commutative @:op(A *= B) public inline function multiplyAssign(by:Vector2d):Vector2d {
		this.x *= by.x;
		this.y *= by.y;
		return this;
	}

	/** Divide `this` component values by given vector. Modifies this instance. Can also be used with `a/=b` operator. **/
	@:commutative @:op(A /= B) public inline function divideAssign(by:Vector2d):Vector2d {
		this.x /= by.x;
		this.y /= by.y;
		return this;
	}

	/** Sets the remainder on `this` component values from given vector. Modifies this instance. Can also be used with `a/=b` operator. **/
	@:commutative @:op(A %= B) public inline function moduloAssign(by:Vector2d):Vector2d {
		this.x %= by.x;
		this.y %= by.y;
		return this;
	}

	/** Clone `this` and sum given vector. Returns new vector instance. Can also be used with `a+b` operator. **/
	@:commutative @:op(A + B) public inline function add(vector:Vector2d):Vector2d {
		return clone().addAssign(vector);
	}

	/** Clone `this` and substract the given vector. Returns new instance. Can also be used with `a-b` operator. **/
	@:commutative @:op(A - B) public inline function substract(vector:Vector2d):Vector2d {
		return clone().substractAssign(vector);
	}

	/** Clone `this` and multiply with given vector. Returns new instance. Can also be used with `a*b` operator. **/
	@:op(A * B) public inline function multiply(vector:Vector2d):Vector2d {
		return clone().multiplyAssign(vector);
	}

	/** Clone `this` and divide by given vector. Returns new instance. Can also be used with `a/b` operator. **/
	@:commutative @:op(A / B) public inline function divide(vector:Vector2d):Vector2d {
		return clone().divideAssign(vector);
	}

	/** Clone `this` and sets remainder from given vector. Returns new instance. Can also be used with `a%b` operator. **/
	@:commutative @:op(A % B) public inline function modulo(vector:Vector2d):Vector2d {
		return clone().moduloAssign(vector);
	}

	/** Sum given value to both of `this` component values. Modifies this instance. Can also be used with `a+=b` operator. **/
	@:op(A += B) public inline function addFloatAssign(v:Float):Vector2d {
		this.x += v;
		this.y += v;
		return this;
	}

	/** Substract given value to both of `this` component values. Modifies this instance. Can also be used with `a-=b` operator. **/
	@:commutative @:op(A -= B) public inline function substractFloatAssign(v:Float):Vector2d {
		this.x -= v;
		this.y -= v;
		return this;
	}

	/** Multiply `this` component values with given value. Modifies this instance. Can also be used with `a*=b` operator. **/
	@:commutative @:op(A *= B) public inline function multiplyFloatAssign(v:Float):Vector2d {
		this.x *= v;
		this.y *= v;
		return this;
	}

	/** Divide `this` component values with given value. Modifies this instance. Can also be used with `a/=b` operator. **/
	@:commutative @:op(A /= B) public inline function divideFloatAssign(v:Float):Vector2d {
		this.x /= v;
		this.y /= v;
		return this;
	}

	/** Sets remainder of `this` component values from given value. Modifies this instance. Can also be used with `a%=b` operator. **/
	@:op(A %= B) public inline function moduloFloatAssign(v:Float):Vector2d {
		this.x %= v;
		this.y %= v;
		return this;
	}

	/** Clone `this` and sum given value. Returns new vector instance. Can also be used with `a+b` operator. **/
	@:commutative @:op(A + B) public inline function addFloat(value:Float):Vector2d {
		return clone().addFloatAssign(value);
	}

	/** Clone `this` and substract given value. Returns new vector instance. Can also be used with `a-b` operator. **/
	@:commutative @:op(A - B) public inline function substractFloat(value:Float):Vector2d {
		return clone().substractFloatAssign(value);
	}

	/** Clone `this` and multiply given value. Returns new vector instance. Can also be used with `a*b` operator. **/
	@:commutative @:op(A * B) public inline function multiplyFloat(value:Float):Vector2d {
		return clone().multiplyFloatAssign(value);
	}

	/** Clone `this` and divide given value. Returns new vector instance. Can also be used with `a/b` operator. **/
	@:commutative @:op(A / B) public inline function divideFloat(value:Float):Vector2d {
		return clone().divideFloatAssign(value);
	}

	/** Clone `this` set remainder from given value. Returns new vector instance. Can also be used with `a%b` operator. **/
	@:commutative @:op(A % B) public inline function moduloFloat(value:Float):Vector2d {
		return clone().moduloFloatAssign(value);
	}

	/** @return `true` if both component values of `this` are same of given vector. **/
	@:commutative @:op(A == B) public inline function equals(v:Vector2d):Bool {
		return this.x == v.x && this.y == v.y;
	}

	/** @return `true` if a component values of `this` is not the same at given vector. **/
	@:commutative @:op(A != B) public inline function notEquals(v:Vector2d):Bool {
		return !(this == v);
	}

	/** Converts `this` vector to array `[x,y]`. **/
	@:to public inline function toArray():Array<Float> {
		return [this.x, this.y];
	}

	/** @return `true` if `this` is `null`. **/
	@:op(!a) public inline function isNil() return this == null;

	/** @return typed Vector2d `null` value **/
	static public inline function nil<A, B>():Vector2d return null;

	@:from public static inline function fromArray(vec:Array<Float>):Vector2d return new Vector2d(vec[0], vec[1]);
	
	#if pixijs
	/** Cast PIXI Point to Vector2d. They unify because both have same component values. **/
	@:from public static inline function fromPixiPoint(point:pixi.core.math.Point):Vector2d return cast point;

	/** Cast this Vector2d to PIXI Point. They unify because both have same component values. **/
	@:to public inline function toPixiPoint():pixi.core.math.Point return cast this;
	#end

	#if openfl
	/** Cast OpenFL Point to Vector2d. They unify because both have same component values. **/
	@:from public static inline function fromOpenFLPoint(point:openfl.geom.Point):Vector2d return cast point;

	/** Cast this Vector2d to OpenFL Point. They unify because both have same component values. **/
	@:to public inline function toOpenFLPoint():openfl.geom.Point return cast this;
	#end

	#if heaps
	/** Cast Heaps Point to Vector2d. They unify because both have same component values. **/
	@:from public static inline function fromHeapsPoint(point:h2d.col.Point):Vector2d return cast point;

	/** Cast this Vector2d to Heaps Point class. They unify because both have same component values. **/
	@:to public inline function toHeapsPoint():h2d.col.Point return cast this;
	#end

	#if kha
	/** Cast Kha Vector2d to Vector2d. They unify because both have same component values. **/
	@:from public static inline function fromKhaVector2d(point:kha.math.Vector2d):Vector2d return cast point;

	/** Cast this Vector2d to Kha Vector2d. They unify because both have same component values. **/
	@:to public inline function toKhaVector2d():kha.math.Vector2d return cast this;
	#end

	public inline function toString(prefix:String = null):String {
		return (if (prefix != null) '${prefix}=' else '') + '{x:${this.x}, y:${this.y}}';
	}
}
