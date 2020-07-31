@IsTest(IsParallel = true)
public class TimezonesTest {
    // some timezones for our tests
    static Timezone tzGmt = TimeZone.getTimeZone('GMT');
    static Timezone tzLocal = UserInfo.getTimeZone();
    static Timezone tzFiji = TimeZone.getTimeZone('Pacific/Fiji');

    // Create dates in different timezones - the Datetime object does not know about the timezone
    static Datetime jan1Gmt = Datetime.newInstanceGmt(2020, 1, 1, 0, 0, 0);  // midnight Jan 1 in GMT
    static Datetime jul1Gmt = Datetime.newInstanceGmt(2020, 7, 1, 0, 0, 0);  // midnight Jul 1 in GMT
    static Datetime jan1Local = Datetime.newInstance(2020, 1, 1, 0, 0, 0);  // midnight Jan 1 in MST - user's local timezone
    static Datetime jan1Fiji = Datetime.newInstance(jan1Gmt.getTime() - tzFiji.getOffset(jan1Gmt));  // midnight Jan 1 in Fiji Time

    @IsTest
    static void it_should_have_known_local_timezone() {
        System.assertEquals('America/Los_Angeles', tzLocal.getID());
    }

    @IsTest
    static void it_should_build_timezone_specific_date_using_gmt_time_minus_offset() {
        // another way to get midnight Jan 1 in local time
        Datetime localDatetime = Datetime.newInstance(jan1Gmt.getTime() - UserInfo.getTimeZone().getOffset(jan1Gmt));
        System.assertEquals(jan1Local, localDatetime);
    }

    @IsTest
    static void it_should_get_offsets_in_standard_and_daylight_time() {
        // Timezone offsets are # of milliseconds from GMT.
        // They require a datetime to know whether to use Daylight Time vs Standard Time
        System.assertEquals(0, tzGmt.getOffset(jan1Gmt));
        System.assertEquals(-28800000, tzLocal.getOffset(jan1Gmt));  // Pacific Standard Time offset
        System.assertEquals(-25200000, tzLocal.getOffset(jul1Gmt));  // Pacific Daylight Time offset
        System.assertEquals(46800000, tzFiji.getOffset(jan1Gmt));  // Fiji Standard Time offset
        System.assertEquals(43200000, tzFiji.getOffset(jul1Gmt));  // Fiji Daylight Time offset
    }

    @IsTest
    static void it_should_get_datetime_as_milliseconds_from_unix_epoch() {
        // Time is # of milliseconds since Jan 1 1970 GMT
        System.assertEquals(1577836800000l, jan1Gmt.getTime());
        System.assertEquals(1577865600000l, jan1Local.getTime());
        System.assertEquals(1577790000000l, jan1Fiji.getTime());
    }

    @IsTest
    static void it_should_build_datetimes_using_offsets() {
        System.assertNotEquals(jan1Gmt.getTime(), jan1Local.getTime());
        // GMT time = local time + offset
        System.assertEquals(jan1Gmt.getTime(), jan1Local.getTime() + tzLocal.getOffset(jan1Gmt));
        System.assertEquals(jan1Gmt, Datetime.newInstance(jan1Local.getTime() + tzLocal.getOffset(jan1Gmt)));
        System.assertEquals(jan1Gmt.getTime(), jan1Fiji.getTime() + tzFiji.getOffset(jan1Gmt));
        System.assertEquals(jan1Gmt, Datetime.newInstance(jan1Fiji.getTime() + tzFiji.getOffset(jan1Gmt)));
    }

    @IsTest
    static void it_should_format_datetimes_in_different_timezones() {
        // datetimes can be formatted in a specific timezone
        String dtFormat = 'yyyy-MM-dd\'T\'HH:mm:ss.SSS';
        // format Jan 1 GMT in different timezones
        System.assertEquals('2020-01-01T00:00:00.000', jan1Gmt.format(dtFormat, tzGmt.getID()));
        System.assertEquals('2019-12-31T16:00:00.000', jan1Gmt.format(dtFormat, tzLocal.getID()));
        System.assertEquals('2020-01-01T13:00:00.000', jan1Gmt.format(dtFormat, tzFiji.getID()));

        // format Jan 1 PST in different timezones
        System.assertEquals('2020-01-01T08:00:00.000', jan1Local.format(dtFormat, tzGmt.getID()));
        System.assertEquals('2020-01-01T00:00:00.000', jan1Local.format(dtFormat, tzLocal.getID()));
        System.assertEquals('2020-01-01T21:00:00.000', jan1Local.format(dtFormat, tzFiji.getID()));

        // format Jan 1 Fiji in different timezones
        System.assertEquals('2019-12-31T11:00:00.000', jan1Fiji.format(dtFormat, tzGmt.getID()));
        System.assertEquals('2019-12-31T03:00:00.000', jan1Fiji.format(dtFormat, tzLocal.getID()));
        System.assertEquals('2020-01-01T00:00:00.000', jan1Fiji.format(dtFormat, tzFiji.getID()));
    }

    List<String> tzsids = new List<String> {
        'Pacific/Kiritimati'
        , 'Pacific/Chatham'
        , 'Pacific/Auckland'
        , 'Pacific/Enderbury'
        , 'Pacific/Fiji'
        , 'Pacific/Tongatapu'
        , 'Asia/Kamchatka'
        , 'Pacific/Norfolk'
        , 'Australia/Lord_Howe'
        , 'Australia/Sydney'
        , 'Pacific/Guadalcanal'
        , 'Australia/Adelaide'
        , 'Australia/Darwin'
        , 'Asia/Seoul'
        , 'Asia/Tokyo'
        , 'Asia/Hong_Kong'
        , 'Asia/Kuala_Lumpur'
        , 'Asia/Manila'
        , 'Asia/Shanghai'
        , 'Asia/Singapore'
        , 'Asia/Taipei'
        , 'Australia/Perth'
        , 'Asia/Bangkok'
        , 'Asia/Ho_Chi_Minh'
        , 'Asia/Jakarta'
        , 'Asia/Rangoon'
        , 'Asia/Dhaka'
        , 'Asia/Yekaterinburg'
        , 'Asia/Kathmandu'
        , 'Asia/Colombo'
        , 'Asia/Kolkata'
        , 'Asia/Karachi'
        , 'Asia/Tashkent'
        , 'Asia/Kabul'
        , 'Asia/Dubai'
        , 'Asia/Tbilisi'
        , 'Europe/Moscow'
        , 'Asia/Tehran'
        , 'Africa/Nairobi'
        , 'Asia/Baghdad'
        , 'Asia/Kuwait'
        , 'Asia/Riyadh'
        , 'Europe/Minsk'
        , 'Africa/Cairo'
        , 'Africa/Johannesburg'
        , 'Asia/Jerusalem'
        , 'Europe/Athens'
        , 'Europe/Bucharest'
        , 'Europe/Helsinki'
        , 'Europe/Istanbul'
        , 'Africa/Algiers'
        , 'Europe/Amsterdam'
        , 'Europe/Berlin'
        , 'Europe/Brussels'
        , 'Europe/Paris'
        , 'Europe/Prague'
        , 'Europe/Rome'
        , 'Europe/Dublin'
        , 'Europe/Lisbon'
        , 'Europe/London'
        , 'GMT'
        , 'Atlantic/Cape_Verde'
        , 'America/Sao_Paulo'
        , 'Atlantic/South_Georgia'
        , 'America/Argentina/Buenos_Aires'
        , 'America/Santiago'
        , 'America/St_Johns'
        , 'America/Halifax'
        , 'America/Puerto_Rico'
        , 'Atlantic/Bermuda'
        , 'America/Caracas'
        , 'America/Bogota'
        , 'America/Indiana/Indianapolis'
        , 'America/Lima'
        , 'America/New_York'
        , 'America/Panama'
        , 'America/Chicago'
        , 'America/El_Salvador'
        , 'America/Mexico_City'
        , 'America/Denver'
        , 'America/Phoenix'
        , 'America/Los_Angeles'
        , 'America/Tijuana'
        , 'America/Anchorage'
        , 'Pacific/Honolulu'
        , 'Pacific/Niue'
        , 'Pacific/Pago_Pago'
    };
}