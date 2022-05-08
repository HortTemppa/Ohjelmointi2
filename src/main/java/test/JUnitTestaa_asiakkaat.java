package test;

import static org.junit.Assert.assertEquals;
import java.util.ArrayList;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;
import org.junit.jupiter.api.MethodOrderer.OrderAnnotation;
import model.Asiakas;
import model.dao.Dao;

@TestMethodOrder(OrderAnnotation.class)
class JUnitTestaa_asiakkaat {

	@Test
	@Order(1) 
	public void testPoistaKaikkiAsiakkaat() {
		//Poistetaan kaikki autot
		Dao dao = new Dao();
		dao.poistaKaikkiAsiakkaat("salasana");
		ArrayList<Asiakas> asiakkaat = dao.listaaKaikki();
		assertEquals(0, asiakkaat.size());
	}
	
	@Test
	@Order(2) 
	public void testLisaaAsiakas() {		

		Dao dao = new Dao();
		Asiakas asiakas_1 = new Asiakas("Teemu", "LAine", "0400503113", "hortteemu");
		Asiakas asiakas_2 = new Asiakas("Horto", "LAine", "0400503333", "jee@yy.fi");
		Asiakas asiakas_3 = new Asiakas("Apina", "LAine", "0400503333", "jaa@yy.fi");
		Asiakas asiakas_4 = new Asiakas("Erkki", "LAine", "0400503333", "kyl@syy.fi");
		assertEquals(true, dao.lisaaAsiakas(asiakas_1));
		assertEquals(true, dao.lisaaAsiakas(asiakas_2));
		assertEquals(true, dao.lisaaAsiakas(asiakas_3));
		assertEquals(true, dao.lisaaAsiakas(asiakas_4));
	}
	
	@Test
	@Order(3) 
	public void testMuutaAsiakas() {
		//Muutetaan yhtä autoa
		Dao dao = new Dao();
		Asiakas muutettava = dao.etsiAsiakas("hortteemu");
		muutettava.setEtunimi("Timo");
		muutettava.setSukunimi("Pentikäinen");
		muutettava.setPuhelin("03330000");
		muutettava.setSposti("hortTimo@naama.fi");
		dao.muutaAsiakas(muutettava, "hortteemu");	
		assertEquals("hortTimo@naama.fi", dao.etsiAsiakas("hortTimo@naama.fi").getSposti());
		assertEquals("Timo", dao.etsiAsiakas("hortTimo@naama.fi").getEtunimi());
		assertEquals("Pentikäinen", dao.etsiAsiakas("hortTimo@naama.fi").getSukunimi());

		assertEquals("03330000", dao.etsiAsiakas("hortTimo@naama.fi").getPuhelin());

	}
	
	@Test
	@Order(4) 
	public void testPoistaAsiakas() {
		Dao dao = new Dao();
		dao.poistaAsiakas("hortTimo@naama.fi");
		assertEquals(null, dao.etsiAsiakas("hortTimo@naama.fi"));
	}

}