import 'package:flutter/material.dart';
import 'package:ezdb_admin/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class PivacyPolicy extends StatefulWidget {
  const PivacyPolicy({Key? key}) : super(key: key);

  @override
  State<PivacyPolicy> createState() => _PayLinkViewState();
}

class _PayLinkViewState extends State<PivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.getResponsiveHorizontalPadding(),
                  vertical: 48,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const ContentWidget(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ContentWidget extends StatelessWidget {
  const ContentWidget({
    Key? key,
  }) : super(key: key);

  final TextStyle headingStyle = const TextStyle(
    color: Colors.white,
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );
  final TextStyle textStyle = const TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
  final TextStyle linkStyle = const TextStyle(
    color: Colors.blue,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.underline,
  );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        // // height: 400,
        width: 700,
        child: Card(
          color: Colors.black45,
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Privacy Policy',
                  style: headingStyle,
                ),
                const SizedBox(height: 16),
                Text(
                  '''ezDB Search App built the ezDB Search App app as a Free app. This SERVICE is provided by ezDB Search App at no cost and is intended for use as is.

This page is used to inform visitors regarding our policies with the collection, use, and disclosure of Personal Information if anyone decided to use our Service.

If you choose to use our Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that we collect is used for providing and improving the Service. We will not use or share your information with anyone except as described in this Privacy Policy.

The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which are accessible at ezDB Search App unless otherwise defined in this Privacy Policy.''',
                  style: textStyle,
                ),
                const SizedBox(height: 16),
                Text(
                  'Information Collection and Use',
                  style: headingStyle,
                ),
                const SizedBox(height: 16),
                Text(
                  '''For a better experience, while using our Service, we may require you to provide us with certain personally identifiable information, including but not limited to ezDB Search App. The information that we request will be retained by us and used as described in this privacy policy.

The app does use third-party services that may collect information used to identify you.

Link to the privacy policy of third-party service providers used by the app''',
                  style: textStyle,
                ),
                const SizedBox(height: 16),

                //unordered list with links
                Container(
                  margin: const EdgeInsets.only(left: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.circle,
                            size: 8,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () async {
                              final Uri url = Uri.parse(
                                  'https://www.google.com/policies/privacy/');
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            child: Text(
                              'Google Play Services',
                              style: linkStyle,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.circle,
                            size: 8,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () async {
                              final Uri url = Uri.parse(
                                  'https://firebase.google.com/policies/analytics');
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            child: Text(
                              'Google Analytics for Firebase',
                              style: linkStyle,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                Text(
                  'Log Data',
                  style: headingStyle,
                ),
                const SizedBox(height: 16),
                Text(
                  '''We want to inform you that whenever you use our Service, in a case of an error in the app we collect data and information (through third-party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol (“IP”) address, device name, operating system version, the configuration of the app when utilizing our Service, the time and date of your use of the Service, and other statistics.''',
                  style: textStyle,
                ),

                const SizedBox(height: 16),

                Text(
                  'Cookies',
                  style: headingStyle,
                ),
                const SizedBox(height: 16),
                Text(
                  '''Cookies are files with a small amount of data that are commonly used as anonymous unique identifiers. These are sent to your browser from the websites that you visit and are stored on your device's internal memory.

This Service does not use these “cookies” explicitly. However, the app may use third-party code and libraries that use “cookies” to collect information and improve their services. You have the option to either accept or refuse these cookies and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service.''',
                  style: textStyle,
                ),

                const SizedBox(height: 16),

                Text(
                  'Service Providers',
                  style: headingStyle,
                ),
                const SizedBox(height: 16),
                Text(
                  '''We may employ third-party companies and individuals due to the following reasons:

   1. To facilitate our Service;  
   2. To provide the Service on our behalf;
   3. To perform Service-related services; or
   4. To assist us in analyzing how our Service is used.

We want to inform users of this Service that these third parties have access to their Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose.''',
                  style: textStyle,
                ),

                const SizedBox(height: 16),

                Text(
                  'Security',
                  style: headingStyle,
                ),

                const SizedBox(height: 16),
                Text(
                  '''We value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and we cannot guarantee its absolute security.''',
                  style: textStyle,
                ),

                const SizedBox(height: 16),

                Text(
                  'Links to Other Sites',
                  style: headingStyle,
                ),

                const SizedBox(height: 16),

                Text(
                  '''This Service may contain links to other sites. If you click on a third-party link, you will be directed to that site. Note that these external sites are not operated by us. Therefore, we strongly advise you to review the Privacy Policy of these websites. We have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services.''',
                  style: textStyle,
                ),

                const SizedBox(height: 16),

                Text(
                  'Children’s Privacy',
                  style: headingStyle,
                ),

                const SizedBox(height: 16),

                Text(
                  '''These Services do not address anyone under the age of 13. We do not knowingly collect personally identifiable information from children under 13 years of age. In the case we discover that a child under 13 has provided us with personal information, we immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact us so that we will be able to do the necessary actions.''',
                  style: textStyle,
                ),

                const SizedBox(height: 16),

                Text(
                  'Changes to This Privacy Policy',
                  style: headingStyle,
                ),

                const SizedBox(height: 16),

                Text(
                  '''We may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Privacy Policy on this page.

This policy is effective as of 2022-09-30''',
                  style: textStyle,
                ),

                const SizedBox(height: 16),

                Text(
                  'Contact Us',
                  style: headingStyle,
                ),

                const SizedBox(height: 16),

                Text(
                  '''If you have any questions or suggestions about our Privacy Policy, do not hesitate to contact us at saadshafiq259@gmail.com.''',
                  style: textStyle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
