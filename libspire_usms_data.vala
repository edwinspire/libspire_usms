////////////////////////////////////////////////
//
//  Author:
//       Edwin De La Cruz <admin@edwinspire.com>
//
//  Copyright (c) 2013 edwinspire
//  Web Site http://edwinspire.com
//
//  Quito - Ecuador
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Lesser General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Lesser General Public License for more details.
//
//  You should have received a copy of the GNU Lesser General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
using GLib;
using Gee;
using edwinspire.Ports;
using edwinspire.GSM.MODEM;
//using Xml;
namespace edwinspire.uSMS {
	public enum SMSType {
		unknown,
		report,
		system,
		manual,
		owner
	}
	// Almacena los datos de un puerto serial desde o hacia la db
	public class SerialPortConf: edwinspire.Ports.Configure {
		public int Id {
			set;
			get;
			default = 0;
		}
		public string Note {
			set;
			get;
			default = "";
		}
		public ArrayList<LogLevelFlags> LogLevel {
			set;
			get;
			default = new ArrayList<LogLevelFlags>();
		}
		public SerialPortConf() {
			LogLevel.add(LogLevelFlags.LEVEL_ERROR);
			LogLevel.add(LogLevelFlags.LEVEL_CRITICAL);
		}
		public SerialPortConf.with_args(int id, bool enable, string port, int baudrate, int databits, Ports.Parity parity, Ports.StopBits stopbits, Ports.HandShaking HS, string note = "", ArrayList<LogLevelFlags> llevel) {
			this.Id = id;
			this.Enable = enable;
			this.Port = port;
			this.BaudRate = baudrate;
			this.DataBits = databits;
			this.HandShake = HS;
			this.Parityp = parity;
			this.StopBitsp = stopbits;
			this.Note = note;
			this.LogLevel = llevel;
		}
	}
}
