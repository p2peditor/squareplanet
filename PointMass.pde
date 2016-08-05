public class CONSTS {
  public static final float G = 0.00000000006674;
}

public class Vec2 {
  public float
    x,
    y;
  public Vec2() { x = 0.0; y = 0.0; }
  public Vec2(float xx, float yy) { x = xx; y = yy; }
}

public class PointMass extends Vec2 {
 
  public Vec2 position;
  public Vec2 velocity;
  public float mass;

  public PointMass() { position = new Vec2(); velocity = new Vec2(); mass = 0.0; }
  public PointMass(float xx, float yy, float mm) { position = new Vec2(xx, yy); velocity = new Vec2(); mass = mm; }

  // return force acting on THIS point caused by PointMass p
  public Vec2 getForceVector(PointMass p) {
    float dx = (p.position.x - this.position.x),
          dy = (p.position.y - this.position.y);
    float r2 = dx*dx + dy*dy; // square of the distance
    float f = CONSTS.G*p.mass*this.mass/r2;
    // now decompose that into components
    float ratio = sqrt(r2)/f;
    float fx = dx/ratio,
          fy = dy/ratio;
    return new Vec2(fx, fy);
  }
  
}