/* libspire_usms.vapi generated by valac.exe 0.12.0, do not modify. */

[CCode (cprefix = "edwinspire", lower_case_cprefix = "edwinspire_")]
namespace edwinspire {
	[CCode (cprefix = "edwinspireuSMS", lower_case_cprefix = "edwinspire_usms_")]
	namespace uSMS {
		[CCode (cheader_filename = "libspire_usms.h")]
		public class ClientConnectiondb : GLib.Object {
			public uint16 Port;
			public string host;
			public ClientConnectiondb ();
			public static string XmlResponse (string host, uint16 port, Gee.HashMap<string,string> request);
		}
		[CCode (cheader_filename = "libspire_usms.h")]
		public class Device : edwinspire.GSM.MODEM.ModemGSM {
			public uint TimeWindowSleep;
			public Device ();
			public void Kill ();
			public void SetPort (edwinspire.uSMS.SerialPortConf sp);
			public edwinspire.uSMS.ProcessCtrl Ctrl { get; set; }
		}
		[CCode (cheader_filename = "libspire_usms.h")]
		public class SerialPortConf : edwinspire.Ports.Configure {
			public SerialPortConf ();
			public SerialPortConf.with_args (int id, bool enable, string port, int baudrate, int databits, edwinspire.Ports.Parity parity, edwinspire.Ports.StopBits stopbits, edwinspire.Ports.HandShaking HS, string note);
			public uint Id { get; set; }
			public string Note { get; set; }
		}
		[CCode (cprefix = "EDWINSPIRE_USMS_PROCESS_CTRL_", cheader_filename = "libspire_usms.h")]
		[Description (blurb = "Control del proceso del servidor usmsd", nick = "Proccess Control")]
		public enum ProcessCtrl {
			None,
			Run,
			Running,
			Sleep,
			Sleeping,
			Restart,
			Restarting,
			Kill,
			Killed
		}
	}
}
