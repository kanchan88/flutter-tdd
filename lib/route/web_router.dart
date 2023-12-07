import 'package:go_router/go_router.dart';
import 'package:workoneerweb/core/provider/login_state_provider.dart';
import 'package:workoneerweb/core/screens/error_404_screen.dart';
import 'package:workoneerweb/feature/auth/presentation/providers/authentication_provider.dart';
import 'package:workoneerweb/feature/client/presentation/pages/add_job_screen.dart';
import 'package:workoneerweb/feature/client/presentation/pages/chat/all_messages.dart';
import 'package:workoneerweb/feature/client/presentation/pages/chat/single_chat_screen.dart';
import 'package:workoneerweb/feature/client/presentation/pages/client_auth_pages/login_screen_client.dart';
import 'package:workoneerweb/feature/client/presentation/pages/client_auth_pages/signup_screen_client.dart';
import 'package:workoneerweb/feature/trader/presentation/pages/account_view_trader.dart';
import 'package:workoneerweb/feature/trader/presentation/pages/add_works.dart';
import 'package:workoneerweb/feature/trader/presentation/pages/all_auctions_trader_view.dart';
import 'package:workoneerweb/feature/trader/presentation/pages/chat/single_chat_screen_trader.dart';
import 'package:workoneerweb/feature/trader/presentation/pages/live_auction_trader_view.dart';
import 'package:workoneerweb/feature/trader/presentation/pages/trader_auth_pages/login_screen_trader.dart';
import 'package:workoneerweb/feature/trader/presentation/pages/trader_auth_pages/signup_screen_trader.dart';
import 'package:workoneerweb/feature/trader/presentation/pages/trader_billing.dart';
import 'package:workoneerweb/feature/trader/presentation/pages/won_auction_trader_view.dart';
import '/feature/client/presentation/pages/billing_view.dart';
import '/feature/client/presentation/pages/my_account.dart';
import '/feature/client/presentation/pages/my_auctions_view.dart';
import '/feature/client/presentation/pages/review_auction_details.dart';

import '../feature/client/presentation/pages/live_auction_details.dart';

class AppRouter {

  late final LoginStateProvider authenticationProvider;

  GoRouter get router => goRouter;

  AppRouter (this.authenticationProvider);

  late final goRouter = GoRouter(

      refreshListenable: authenticationProvider,
      initialLocation: '/client-register',

      routes: [

        GoRoute(
          name: 'trader-login',
          path: '/trader-login',
          builder: (context, state) => const LoginScreenTrader(),
        ),

        GoRoute(
          name: 'trader-register',
          path: '/trader-register',
          builder: (context, state) => const SignUpScreenTrader(),
        ),

        GoRoute(
            name: 'trader',
            path: '/trader',
            builder: (context, state) => const AllAuctionsTraderView(),
            routes: [

              GoRoute(
                name: 'trader-live-auction',
                path: 'live-auction/:id',
                builder: (context, state) =>
                    LiveAuctionTraderView(
                      jobId: state.params['id'].toString(),
                    ),
              ),

              GoRoute(
                name: 'won-auction',
                path: 'won-auction/:id',
                builder: (context, state) =>
                    WonAuctionTraderView(
                      jobId: state.params['id'].toString(),
                    ),
              ),

              GoRoute(
                name: 'trader-account',
                path: 'account',
                builder: (context, state) => const AccountViewTrader(),
              ),

              GoRoute(
                name: 'trader-billing',
                path: 'billing',
                builder: (context, state) => const BillingViewTrader(),
              ),

              GoRoute(
                name: 'add-works',
                path: 'add-work',
                builder: (context, state) => const TraderOnboarding(),
              ),

            ]
        ),

        GoRoute(
          name: 'client-login',
          path: '/client-login',
          builder: (context, state) => const LoginScreenClient(),
        ),

        GoRoute(
          name: 'register',
          path: '/client-register',
          builder: (context, state) => const SignUpScreenClient(),
        ),

        GoRoute(
          name: 'chat',
          path: '/chat/:job',
          builder: (context, state) =>
              DisplayAllMessages(
                jobId: state.params['job'].toString(),
              ),
        ),

        GoRoute(
          name: 'single-chat',
          path: '/chat/:job/:trader',
          builder: (context, state) =>
              SingleChatScreen(
                chatId: state.params['job'].toString(),
                traderId: state.params['trader'].toString(),
              ),
        ),

        GoRoute(
          name: 'trader-single-chat',
          path: '/trader-chat/:job/:trader',
          builder: (context, state) =>
              SingleChatScreenTrader(
                chatId: state.params['job'].toString(),
                traderId: state.params['trader'].toString(),
              ),
        ),

        GoRoute(
          name: 'trader-single-admin-chat',
          path: '/trader-admin-chat/:job/:trader',
          builder: (context, state) =>
              SingleChatScreen(
                chatId: state.params['job'].toString(),
                traderId: state.params['trader'].toString(),
              ),
        ),

        GoRoute(
            name: 'client',
            path: '/client',
            builder: (context, state) => const ShowMyAuctions(),
            routes: [

              GoRoute(
                name: 'add-auction',
                path: 'add-auction',
                builder: (context, state) => const ShowAddAuctionScreen(),
              ),

              GoRoute(
                name: 'live-auction',
                path: 'live-auction/:id',
                builder: (context, state) =>
                    LiveAuctionDetailsView(
                      jobId: state.params['id'].toString(),
                    ),
              ),

              GoRoute(
                name: 'review-auction',
                path: 'review-auction/:id',
                builder: (context, state) =>
                    ReviewAuctionDetailsView(
                      jobId: state.params['id'].toString(),
                    ),
              ),

              GoRoute(
                name: 'account',
                path: 'account',
                builder: (context, state) => const ShowMyAccountClient(),
              ),

              GoRoute(
                name: 'billing',
                path: 'billing',
                builder: (context, state) => const ShowBillingViewClient(),
              ),

            ]
        ),

      ],

      errorBuilder: (context, state) => const Error404Screen(),

      redirect: (state) {

        if((state.location=='/client' || state.location=='/client/billing' || state.location=='/client/account') && authenticationProvider.getUserId!.isEmpty ){
          return '/client-login';
        }

        if((state.location=='/trader' || state.location=='/trader/billing' || state.location=='/trader/account') && authenticationProvider.getUserId!.isEmpty ){
          return '/trader-login';
        }

        return null;

      }


  );
}

