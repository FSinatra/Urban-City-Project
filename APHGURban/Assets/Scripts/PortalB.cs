using UnityEngine;
using System.Collections;

public class PortalB : MonoBehaviour {
	
	public GameObject PortalY;
	
	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	public void OnTriggerEnter( Collider col)
	{
		if ( col.transform.CompareTag("Player"))
		{

			col.transform.position = PortalY.transform.position + new Vector3(0, 2, 0) + this.transform.forward; 	
		}
	}
}
