/////////////////////////////////////////////////
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
using Sqlite;
using edwinspire.uSMS;
using edwinspire.Ports;
namespace edwinspire.uSMS {
/*
	public class uSMSDataBase:GLib.Object {
		private  Database db;
		private int rc = 0;
		public bool isOpen {
			public get;
			private set;
			default = false;
		}
		public uSMSDataBase() {
		}
		public void Open() {
			if ((rc = Database.open ("mem.sqlite", out db)) == 1) {
				printerr ("Can't open database: %s\n", db.errmsg ());
				isOpen = false;
			} else {
				isOpen = true;
				CreateDb();
			}
		}
		private bool CreateDb() {
			bool Retorno = false;
			var Query = new StringBuilder();
			Statement stmt;
			//  int rc = 0;
			Query.append("""CREATE TABLE "serialport" ("idport" INTEGER PRIMARY KEY ,"port" TEXT DEFAULT ('COM1') unique ,"enable" BOOL DEFAULT (0) ,"baudrate" INTEGER DEFAULT (0) ,"databits" INTEGER DEFAULT (8) ,"parity" INTEGER DEFAULT (0) ,"stopbits" INTEGER DEFAULT (1) ,"handshake" INTEGER DEFAULT (0) ,"note" TEXT,"loglevel" TEXT)""");
			if ((rc = db.prepare_v2 (Query.str, -1, out stmt, null)) == 1) {
				printerr ("CreateDb SQL error: %d, %s\n", rc, db.errmsg ());
				//        return;
			}
			if(stmt != null) {

				//stmt.bind_text(1, "serialport");
				//stmt.bind_text(5, conf.HomePage);
				//stmt.bind_int(2, contrl.Id);
				stmt.step();
				//print(stmt.sql());
				//      printerr ("SQL error: %d, %s\n", rc, db.errmsg ());
				//  printerr ("SQL %s\n", stmt.sql());
				db.exec("COMMIT");
				if(db.changes ()>0) {
					Retorno = true;
					printerr ("CreateDb SQL changes: %d, %i\n", rc, db.changes ());
				} else {
					printerr ("CreateDb SQL error: %d, %s\n", rc, db.errmsg ());
				}
			}
			//        printerr ("SQL changes: %d, %i\n", rc, db.changes ());
			return Retorno;
		}
		public  int64 Insert(SerialPortConf row) {
			int64 Retorno = 0;
			Statement stmt;
			//  int rc = 0;
			//  int cols;
			if ((rc = db.prepare_v2 ("INSERT INTO serialport (port, enable, baudrate, databits, parity, stopbits, handshake, note) VALUES (?, ?, ?, ?, ?, ?, ?, ?)", -1, out stmt, null)) == 1) {
				printerr ("SQL error: %d [%s], %s\n", rc, FILE_CONF, db.errmsg ());
				//        return;
			}
			if(stmt != null) {
				//stmt.bind_int(1, (int)row.Id);
				stmt.bind_text(1, row.Port);
				stmt.bind_int(2, (int)row.Enable);
				stmt.bind_int(3, (int)row.BaudRate);
				stmt.bind_int(4, (int)row.DataBits);
				stmt.bind_int(5, (int)row.Parityp);
				stmt.bind_int(6, (int)row.StopBitsp);
				stmt.bind_int(7, (int)row.HandShake);
				stmt.bind_text(8, row.Note);
				stmt.step();
				//  printerr ("SQL %s\n", stmt.sql());
				db.exec("COMMIT");
				if(db.changes ()>0) {
					printerr ("SQL changesAok del: %d, %i\n", rc, db.changes ());
					Retorno = db.last_insert_rowid ();
				} else {
					printerr ("SQL changesB del: %d, %i\n", rc, db.changes ());
					printerr ("SQL error: %d [%s], %s\n", rc, FILE_CONF, db.errmsg ());
				}
			}
			return Retorno;
		}
	}
*/
}
