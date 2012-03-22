using UnityEngine;
using System.Collections;

public class AIScript : MonoBehaviour {
	public GameObject Waypoint1;
	public GameObject Waypoint2;
	public GameObject Waypoint3;
	public GameObject Waypoint4;
	public float moveSpeed = 5;
	public Transform myTransform;
	public int goingTowards = 1;
	public float deltaX;
	public float deltaZ;
	// Use this for initialization
	void Start () {

	}
	
	// Update is called once per frame
	void Update () {
		if (goingTowards == 1)
		{
		this.transform.LookAt(Waypoint1.transform.position);
		myTransform = this.transform;
		myTransform.position += myTransform.forward * Time.deltaTime * moveSpeed;
		deltaX = Mathf.Abs(this.transform.position.x - Waypoint1.transform.position.x);
			deltaZ = Mathf.Abs(this.transform.position.z - Waypoint1.transform.position.z);
		if (deltaX < 1 && deltaZ < 1)
			{
		goingTowards = 2;
			}
		}
		else if (goingTowards == 2)
		{
		this.transform.LookAt(Waypoint2.transform.position);
		myTransform = this.transform;
		myTransform.position += myTransform.forward * Time.deltaTime * moveSpeed;	
		deltaX = Mathf.Abs(this.transform.position.x - Waypoint2.transform.position.x);
			deltaZ = Mathf.Abs(this.transform.position.z - Waypoint2.transform.position.z);
		if (deltaX < 1 && deltaZ < 1)
			{
		goingTowards = 3;
			}
		}
		else if (goingTowards == 3)
		{
		this.transform.LookAt(Waypoint3.transform.position);
		myTransform = this.transform;
		myTransform.position += myTransform.forward * Time.deltaTime * moveSpeed;	
		deltaX = Mathf.Abs(this.transform.position.x - Waypoint3.transform.position.x);
			deltaZ = Mathf.Abs(this.transform.position.z - Waypoint3.transform.position.z);
		if (deltaX < 1 && deltaZ < 1)
			{
		goingTowards = 4;
			}
		}
		else if (goingTowards == 4)
		{
		this.transform.LookAt(Waypoint4.transform.position);
		myTransform = this.transform;
		myTransform.position += myTransform.forward * Time.deltaTime * moveSpeed;	
			deltaX = Mathf.Abs(this.transform.position.x - Waypoint4.transform.position.x);
			deltaZ = Mathf.Abs(this.transform.position.z - Waypoint4.transform.position.z);
		if (deltaX < 1 && deltaZ < 1)
			{
		goingTowards = 1;
			}
		}
	}
}
